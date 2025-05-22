---@module 'dotvim.commons.vim'

local M = {}

---Invokes the given callback and trie to restore the cursor position.
---@generic T
---@param callback fun():T
function M.preserve_cursor_position(callback)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  local ret = { callback() }

  vim.schedule(function()
    local lastline = vim.fn.line("$")

    if line > lastline then
      line = lastline
    end

    vim.api.nvim_win_set_cursor(0, { line, col })
  end)

  return unpack(ret)
end

---Returns the value of a buffer variable, or nil if it doesn't exist.
---@param bufnr number
---@param key string
---@return any?
function M.buf_get_var(bufnr, key)
  local succ, value = pcall(vim.api.nvim_buf_get_var, bufnr, key)
  if succ then
    return value
  end
end

---Returns the keymap to a given mode and lhs exactly
---@param mode string
---@param lhs string
---@return vim.api.keyset.get_keymap?
function M.get_exactly_keymap(mode, lhs)
  local keymap = vim.api.nvim_get_keymap(mode)
  for _, map in ipairs(keymap) do
    ---@diagnostic disable-next-line: undefined-field
    if map.lhs == lhs then
      return map
    end
  end
  return nil
end

return M
