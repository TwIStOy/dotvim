---@module 'dotvim.configs.relativenumber'

-- Configuration for relative number toggling functionality

local exclude_ft = {
    "qf",
}
local function should_show_relativenumber()
  local ft = vim.api.nvim_get_option_value("ft", { buf = 0 })
  if vim.list_contains(exclude_ft, ft) then
    return false
  end
  return vim.api.nvim_get_option_value("nu", { win = 0 })
end

local group = vim.api.nvim_create_augroup("dotvim.relative_number", { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  group = group,
  pattern = "*",
  callback = function()
    if should_show_relativenumber() and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
      vim.api.nvim_set_option_value("rnu", true, { win = 0 })
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  group = group,
  pattern = "*",
  callback = function(args)
    if should_show_relativenumber() then
      vim.api.nvim_set_option_value("rnu", false, { win = 0 })
    end
    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == 'CmdlineEnter' then
        if not vim.tbl_contains({ '@', '-' }, vim.v.event.cmdtype) then
            vim.cmd.redraw()
        end
    end
  end,
})
