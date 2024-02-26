local M = {}

---@return string?
function M.current_gui()
	if vim.g.vscode then
		return "vscode"
	end
	return nil
end

return M
