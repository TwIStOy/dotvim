local TSUtils = require("ht.utils.ts")

local function _find_topmost_parent(node, types, validator)
  local ntypes = TSUtils.make_type_matcher(types)

  validator = validator or function()
    return true
  end

  ---@param root TSNode?
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

local function make_expand_params_resolver(root_updator)
  local context_matcher = function(_, _, match, captures)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] - #match - 1 }
    local exclude_cursor_range = { cursor[1] - 1, cursor[2] - 1 }

    local _ts_update_disabled = vim.api.nvim_buf_get_var(0, "_ts_disabled")
    if _ts_update_disabled then
      vim.treesitter.get_parser(0):parse(true)
    end

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
      local start_row, start_col, _, _ = vim.treesitter.get_node_range(root)

      -- start_row and start_col is correct
      local capture = vim.api.nvim_buf_get_text(
        0,
        start_row,
        start_col,
        cursor[1] - 1,
        cursor[2],
        {}
      )
      local last_line = capture[#capture]
      capture[#capture] = last_line:sub(1, #last_line - #match)

      if #capture == 1 then
        capture = capture
      end

      return {
        trigger = match,
        captures = captures,
        clear_region = {
          from = {
            start_row,
            start_col,
          },
          to = {
            cursor[1] - 1,
            cursor[2],
          },
        },
        env_override = {
          POSTFIX_MATCH = capture,
        },
      }
    else
      return nil
    end
  end
  return context_matcher
end

---@param types string | table<string, number> | table<number, string>
local function make_topmost_parent_expand_params_resolver(types)
  local root_updator = function(root, validator)
    return _find_topmost_parent(root, types, validator)
  end
  return make_expand_params_resolver(root_updator)
end

return {
  make_ts_topmost_parent = make_topmost_parent_expand_params_resolver,
}
