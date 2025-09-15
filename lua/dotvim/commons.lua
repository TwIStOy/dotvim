---@module 'dotvim.commons'
local M = vim._defer_require("dotvim.commons", {
  fs = ..., ---@module 'dotvim.commons.fs'
  vim = ..., ---@module 'dotvim.commons.vim'
  validator = ..., ---@module 'dotvim.commons.validator'
  lsp = ..., ---@module 'dotvim.commons.lsp'
  nix = ..., ---@module 'dotvim.commons.nix'
  option = ..., ---@module 'dotvim.commons.option'
  fn = ..., ---@module 'dotvim.commons.fn'
})

--[[
Basic utilities for tables
--]]

---Returns a new table which keys are the values of the input array.
---@param array any[]
---@return table
function M.array_values_to_lookup(array, value)
  vim.validate("array", array, vim.isarray)
  if value == nil then
    value = true
  end
  return vim.iter(array):fold({}, function(acc, v)
    acc[v] = value
    return acc
  end)
end

---Returns the location of a program in current environment.
---@param program string
---@return string|nil
function M.which(program)
  if vim.fn.executable(program) == 1 then
    return program
  end

  if M.nix.in_nix_env() then
    local config = M.nix.get_nix_aware_config()
    return vim.tbl_get(config, "bin", program)
  end

  return nil
end

return M
