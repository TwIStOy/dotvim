local M = {}

---@param opts? dora.config.SetupOptions
function M.setup(opts)
	require("dora.config").setup(opts)
end

return M
