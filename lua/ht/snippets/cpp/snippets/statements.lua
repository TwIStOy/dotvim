local UtilsTs = require("ht.utils.ts")
local UtilsTbl = require("ht.utils.table")

local ls = require("luasnip")
local t = ls.text_node
local f = ls.function_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local extras = require("luasnip.extras")
local rep = extras.rep
local ht_snippet = require("ht.snippets.snippet")
local snippet = ht_snippet.build_snippet
local i = ht_snippet.insert_node
local c = ht_snippet.choice_node

local header_ext = {
  "hh",
  "h",
  "hpp",
  "hxx",
  "h++",
  "inl",
  "ipp",
  "tcc",
}

---@param node TSNode?
---@return { [1]: number, [2]: number }?
local function in_argument(node, source)
  if node == nil then
    return nil
  end

  node = UtilsTs.find_first_parent(node, { "argument_list" })

  if node == nil then
    return nil
  end

  local start_row, start_col, _, _ = vim.treesitter.get_node_range(node)

  return { start_row, start_col }
end

---@param node TSNode?
---@return { [1]: number, [2]: number }?
local function in_function_body(node, source)
  if node == nil then
    return nil
  end

  node = UtilsTs.find_first_parent(
    node,
    { "function_definition", "lambda_expression" }
  )

  if node == nil then
    return nil
  end

  local start_row, start_col, _, _ = vim.treesitter.get_node_range(node)
  return { start_row, start_col }
end

local function in_header_file()
  local ext = vim.fn.expand("%:e")
  if vim.list_contains(header_ext, ext) then
    return true
  end
  return false
end

local function in_class_body(node, source)
  if node == nil then
    return nil
  end

  node = UtilsTs.find_first_parent(node, {
    "struct_specifier",
    "class_specifier",
  })

  if node == nil then
    return nil
  end

  local start_row, start_col, _, _ = vim.treesitter.get_node_range(node)
  return { start_row, start_col }
end

local lambda_snippet_node = sn(
  nil,
  fmta(
    [[
    [this, &](<>) <> {
      <>
    }
    ]],
    {
      i(2),
      c(1, {
        t("mutable"),
        t(""),
      }),
      i(0),
    }
  )
)

local function make_function_snippet_node(env)
  local fmt_args = {
    body = i(0),
    inline_inline = t(""),
  }
  local storage_specifiers = {
    "",
    "static ",
  }
  if not env.CPP_IN_HEADER_FILE then
    storage_specifiers[#storage_specifiers + 1] = "inline "
    storage_specifiers[#storage_specifiers + 1] = "static inline "
  else
    fmt_args.inline_inline = t("inline ")
  end

  local specifiers = {
    "",
    " noexcept",
  }
  if env.CPP_IN_CLASS_BODY then
    specifiers[#specifiers + 1] = " const"
    specifiers[#specifiers + 1] = " const noexcept"
  end
  fmt_args.storage_specifier = c(
    1,
    UtilsTbl.list_map(storage_specifiers, function(ss)
      return t(ss)
    end),
    { desc = "storage specifier" }
  )
  fmt_args.ret = i(2, "auto", { desc = "return type" })
  fmt_args.name = i(3, "name", { desc = "function name" })
  fmt_args.args = i(4, "args", { desc = "function arguments" })
  fmt_args.specifier = c(
    5,
    UtilsTbl.list_map(specifiers, function(ss)
      return t(ss)
    end),
    { desc = "specifier" }
  )
  return sn(
    nil,
    fmta(
      [[
      <storage_specifier><inline_inline>auto <name>(<args>)<specifier> ->> <ret> {
        <body>
      }
      ]],
      fmt_args
    )
  )
end

local function reparse_buffer(ori_bufnr, match)
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

return {
  snippet {
    "fn",
    name = "Define a function/lambda",
    dscr = "Define a function/lambda",
    mode = "w",
    resolveExpandParams = function(_, _, match, captures)
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local buf = vim.api.nvim_get_current_buf()
      local parser, source = reparse_buffer(buf, match)
      local pos = {
        row - 1,
        col - #match,
      }
      local node = parser:named_node_for_range {
        pos[1],
        pos[2],
        pos[1],
        pos[2],
      }
      local ret = {
        trigger = match,
        capture = captures,
        env_override = {
          CPP_IN_ARGUMENT = in_argument(node, source),
          CPP_IN_FUNCTION_BODY = in_function_body(node, source),
          CPP_IN_CLASS_BODY = in_class_body(node, source),
          CPP_IN_HEADER_FILE = in_header_file(),
        },
      }
      parser:destroy()
      return ret
    end,
    nodes = d(1, function(_, parent)
      local env = parent.env
      local last_type, last_type_row, last_type_col
      local keys = {
        "CPP_IN_ARGUMENT",
        "CPP_IN_FUNCTION_BODY",
        "CPP_IN_CLASS_BODY",
      }
      for _, key in ipairs(keys) do
        if env[key] ~= nil then
          if last_type == nil then
            last_type = key
            last_type_row = env[key][1]
            last_type_col = env[key][2]
          else
            if
              last_type_row < env[key][1]
              or (last_type_row == env[key][1] and last_type_col < env[key][2])
            then
              last_type = key
              last_type_row = env[key][1]
              last_type_col = env[key][2]
            end
          end
        end
      end

      if
        last_type == "CPP_IN_ARGUMENT" or last_type == "CPP_IN_FUNCTION_BODY"
      then
        return lambda_snippet_node
      else
        return make_function_snippet_node(env)
      end
    end, {}),
  },
}

