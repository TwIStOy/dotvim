local TSUtils = require("ht.utils.ts")

local function _find_topmost_parent(node, types, validator)
  local ntypes = TSUtils.make_type_matcher(types)

  validator = validator or function()
    return true
  end

  ---@param root TSNode
  ---@return TSNode | nil
  local function find_parent_impl(root)
    if root == nil then
      return nil
    end
    local res = nil
    if ntypes[root:type()] and validator(root) then
      res = root
    end
    return find_parent_impl(root:parent()) or res
  end

  return find_parent_impl(node)
end

local function make_matcher(root_updator)
  ---@param line_to_cursor string
  ---@param trigger string
  return function(line_to_cursor, trigger)
    if
      line_to_cursor:sub(#line_to_cursor - #trigger + 1, #line_to_cursor)
      ~= trigger
    then
      return nil
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] - #trigger - 1 }
    local exclude_cursor_range = { cursor[1] - 1, cursor[2] - 1 }

    local buf = vim.api.nvim_win_get_buf(0)
    local root = vim.treesitter.get_node {
      bufnr = buf,
      pos = cursor_range,
    }
    if root_updator ~= nil then
      root = root_updator(root, function(node)
        local start_row, start_col, end_row, end_col =
          vim.treesitter.get_node_range(node)

        if
          start_row > exclude_cursor_range[1]
          or end_row < exclude_cursor_range[1]
        then
          return true
        end
        if
          start_row == exclude_cursor_range[1]
          and start_col > exclude_cursor_range[2]
        then
          return true
        end
        if
          end_row == exclude_cursor_range[1]
          and end_col < exclude_cursor_range[2]
        then
          return true
        end

        return false
      end)
    end

    if root ~= nil then
      -- try to use the text from `line_to_cursor`
      local start_row, start_col, end_row, end_col =
        vim.treesitter.get_node_range(root)
      local text = line_to_cursor:sub(start_col + 1)
      local capture =
        line_to_cursor:sub(start_col + 1, #line_to_cursor - #trigger)

      return text, { capture }
      -- origin:
      -- local node_text = vim.treesitter.get_node_text(root, 0)
      -- local captures = { node_text }
      -- return node_text .. trigger, captures
    else
      return nil
    end
  end
end

---@param types string | table<string, number> | table<number, string>
local function make_topmost_parent_matcher_maker(types)
  local root_updator = function(root, validator)
    return _find_topmost_parent(root, types, validator)
  end
  ---@diagnostic disable-next-line: unused-local
  local matcher_maker = function(trigger)
    return make_matcher(root_updator)
  end
  return matcher_maker
end

return {
  ts_topmost_parent = make_topmost_parent_matcher_maker,
}
