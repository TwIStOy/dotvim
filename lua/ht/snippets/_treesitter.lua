local evim = require("ht.vim")
local tbl = require("ht.utils.table")

---Get the language of the buffer.
---@param bufnr number?
---@return string?
local function get_lang(bufnr)
  bufnr = vim.F.if_nil(bufnr, 0)
  local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
  local lang = vim.treesitter.language.get_lang(ft) or ft
  return lang
end

---@class ht.snippet.TSParserWrapper
---@field parser LanguageTree
---@field source string|number
---@field ori_buf number
---@field buf_lang string
local TSParserWrapper = {}

---@param parser ht.snippet.TSParserWrapper?
---@return string
local function _tsparser_to_string(parser)
  if parser == nil then
    return "nil"
  end
  return ("trees: %d, source: %s, lang: %s"):format(
    #parser.parser:trees(),
    type(parser.source) == "number" and tostring(parser.source) or "[COPYED]",
    parser.buf_lang
  )
end

---@param bufnr number?
---@param parser LanguageTree
---@param source string|number
---@return ht.snippet.TSParserWrapper?
local function new_parser_wrapper(bufnr, parser, source)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buf_lang = get_lang(bufnr)
  if buf_lang == nil then
    return
  end

  local o = {
    parser = parser,
    source = source,
    ori_buf = bufnr,
    buf_lang = buf_lang,
  }

  setmetatable(o, {
    __index = TSParserWrapper,
    __tostring = _tsparser_to_string,
  })
  return o
end

---@param pos { [1]: number, [2]: number }?
---@return TSNode?
function TSParserWrapper:get_node_at_pos(pos)
  pos = vim.F.if_nil(pos, evim.get_cursor_0ind())
  local row, col = pos[1], pos[2]
  assert(
    row >= 0 and col >= 0,
    "Invalid position: row and col must be non-negative"
  )
  local range = { row, col, row, col }
  return self.parser:named_node_for_range(range)
end

---@param node TSNode
---@param cursor { [1]: number, [2]: number }
---@param matched_trigger string
---@return number, number, string[]
function TSParserWrapper:get_node_text(node, cursor, matched_trigger)
  local text
  local start_row, start_col, _, _ = vim.treesitter.get_node_range(node)
  if type(self.source) == "string" then
    text = vim.treesitter.get_node_text(node, self.source)
    text = vim.split(text, "\n", {
      plain = true,
      trimempty = false,
    })
  else
    text = vim.api.nvim_buf_get_text(
      0,
      start_row,
      start_col,
      cursor[1] - 1,
      cursor[2],
      {}
    )
    local last_line = text[#text]
    text[#text] = last_line:sub(1, #last_line - #matched_trigger)
  end
  return start_row, start_col, text
end

---@class ht.snippet.TSCaptures
---@field query_group string? default to "snippet"
---@field capture_text string? default to nil
---@field captures string|string[]

---@class ht.snippet.TSQueryOpts
---@field query Query
---@field root TSNode
---@field insert fun(capture_name: string): boolean
---@field start number
---@field stop number

---@param opts ht.snippet.TSCaptures
---@param root TSNode?
---@param root_lang string?
---@return ht.snippet.TSQueryOpts?
function TSParserWrapper:prepare_query(opts, root, root_lang)
  if root == nil then
    -- try first tree's root
    local first_tree = self.parser:trees()[1]
    if first_tree then
      root = first_tree:root()
    end
  end
  if root == nil then
    return
  end

  local range = { root:range() }

  if not root_lang then
    local lang_tree = self.parser:language_for_range(range)

    if lang_tree then
      root_lang = lang_tree:lang()
    end
  end
  if not root_lang then
    return
  end

  ---@type Query?
  local query
  local insert

  if opts.query_group == nil and opts.capture_text == nil then
    return
  end
  if opts.capture_text then
    query = vim.treesitter.query.parse(self.buf_lang, opts.capture_text)
    insert = function()
      return true
    end
  else
    opts.query_group = opts.query_group or "snippet"
    local search_table = tbl.normalize_search_table(opts.captures)
    query = vim.treesitter.query.get(self.buf_lang, opts.query_group)
    insert = function(capture_name)
      return search_table and search_table[capture_name]
    end
  end

  if not query then
    return
  end

  return {
    query = query,
    root = root,
    insert = insert,
    start = range[1],
    stop = range[3] + 1,
  }
end

---@param captures ht.snippet.TSCaptures
---@return { name: string, node: TSNode }[]?
function TSParserWrapper:get_capture_matches(captures)
  local results = {}

  local opts = self:prepare_query(captures)
  if opts == nil then
    return
  end

  local matches =
    opts.query:iter_matches(opts.root, self.source, opts.start, opts.stop)

  while true do
    local pattern, match = matches()
    if pattern == nil then
      break
    end

    for id, node in ipairs(match) do
      local capture_name = opts.query.captures[id]
      if opts.insert and opts.insert(capture_name) then
        results[#results + 1] = {
          name = capture_name,
          node = node,
        }
      end
    end
  end

  return results
end

---@param captures ht.snippet.TSCaptures
---@param pos { [1]: number, [2]: number }?
---@return { name: string, node: TSNode }[]?
function TSParserWrapper:captures_at_pos(captures, pos)
  pos = vim.F.if_nil(pos, evim.get_cursor_0ind())
  local matches = self:get_capture_matches(captures)
  if matches == nil then
    return
  end
  local results = {}
  for _, match in ipairs(matches) do
    if vim.treesitter.is_in_node_range(match.node, pos[1], pos[2]) then
      results[#results + 1] = match
    end
  end
  return results
end

local function wrap_with_update_buffer(ori_bufnr, match, fun)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local function update_current_buffer()
    local lines = vim.api.nvim_buf_get_lines(ori_bufnr, row - 1, row, true)
    assert(#lines == 1)
    local current_line = lines[1]
    local current_line_left = current_line:sub(1, col - #match)
    local current_line_right = current_line:sub(col + 1)

    vim.api.nvim_buf_set_lines(
      ori_bufnr,
      row - 1,
      row,
      true,
      { current_line_left .. current_line_right }
    )
    local parser, source = vim.treesitter.get_parser(ori_bufnr), ori_bufnr
    local _ts_update_disabled = vim.api.nvim_buf_get_var(0, "_ts_disabled")
    if _ts_update_disabled then
      parser:parse(true)
    else
      parser:parse()
    end

    return parser, source, current_line
  end

  local function restore_current_buffer(ori_line)
    vim.api.nvim_buf_set_lines(ori_bufnr, row - 1, row, true, {
      ori_line,
    })
    local parser, source = vim.treesitter.get_parser(ori_bufnr), ori_bufnr
    parser:parse()
    vim.api.nvim_win_set_cursor(0, { row, col })
    return parser, source
  end

  local parser, source, ori_line = update_current_buffer()

  local ret = { fun(parser, source) }

  restore_current_buffer(ori_line)

  return unpack(ret)
end

local function wrap_with_reparse_buffer(ori_bufnr, match, fun)
  local function reparse_buffer()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local lines = vim.api.nvim_buf_get_lines(ori_bufnr, 0, -1, false)
    local current_line = lines[row]
    local current_line_left = current_line:sub(1, col - #match)
    local current_line_right = current_line:sub(col + 1)
    lines[row] = current_line_left .. current_line_right
    local lang = vim.treesitter.language.get_lang(vim.bo[ori_bufnr].filetype)
      or vim.bo[ori_bufnr].filetype

    local source = table.concat(lines, "\n")
    ---@type LanguageTree
    local parser = vim.treesitter.get_string_parser(source, lang)
    parser:parse(true)

    return parser, source
  end

  local parser, source = reparse_buffer()

  local ret = { fun(parser, source) }

  parser:destroy()

  return unpack(ret)
end

return {
  new_parser_wrapper = new_parser_wrapper,
  wrap_with_update_buffer = wrap_with_update_buffer,
  wrap_with_reparse_buffer = wrap_with_reparse_buffer,
}
