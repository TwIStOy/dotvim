local all_plugins_options = {}

---@param opts dora.lib.PluginOptions
local function register(opts)
	all_plugins_options[opts[1]] = opts
end

---@param opts dora.lib.PluginOptions
local function override_opts(name, opts)
	if all_plugins_options[name] == nil then
		error("Plugin " .. name .. " not found")
	end
	all_plugins_options[name] = vim.tbl_extend("force", all_plugins_options, opts)
end

return {
	register = register,
	override_opts = override_opts,
}
