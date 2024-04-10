local M = {}

local uncountable_filetypes = {
  ["quickfix"] = true,
  ["defx"] = true,
  ["CHADTree"] = true,
  ["NvimTree"] = true,
  ["noice"] = true,
  ["fidget"] = true,
  ["scrollview"] = true,
  ["notify"] = true,
  ["Trouble"] = true,
  ["sagacodeaction"] = true,
  ["rightclickpopup"] = true,
  ["DiffviewFiles"] = true,
  ["neo-tree"] = true,
  ["neo-tree-popup"] = true,
  ["NvimSeparator"] = true,
  ["neotest-summary"] = true,
}

function M.is_uncountable(win_id)
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  local ft = vim.api.nvim_get_option_value("ft", {
    buf = buf_id,
  })
  local bt = vim.api.nvim_get_option_value("buftype", {
    buf = buf_id,
  })
  return (uncountable_filetypes[ft] ~= nil and uncountable_filetypes[ft])
    or (uncountable_filetypes[bt] ~= nil and uncountable_filetypes[bt])
end

function M.check_last_window()
  local n = vim.api.nvim_call_function("winnr", { "$" })
  local total = n
  for i = 1, n do
    local win_id = vim.api.nvim_call_function("win_getid", { i })
    if M.is_uncountable(win_id) then
      total = total - 1
    end
  end

  if total == 0 then
    if vim.api.nvim_call_function("tabpagenr", { "$" }) == 1 then
      vim.api.nvim_command("quitall!")
    else
      vim.api.nvim_command("tabclose")
    end
  end
end

return M
