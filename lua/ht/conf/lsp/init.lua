---@type ht.lsp.Server[]
local all_servers = (function()
  local servers = {}
  servers[#servers + 1] = require("ht.conf.lsp.servers.rime_ls")
  return servers
end)()

local all_formatters = require("ht.conf.external_tool.formatters")

---@param servers ht.lsp.Server[]
---@param tools ht.external_tool.Formatter[]
---@return ht.MasonPackage[]
local function collect_mason_packages(servers, tools)
  local result = {}
  for _, server in ipairs(servers) do
    local pkg = server:mason_package()
    if pkg ~= nil then
      result[#result + 1] = pkg
    end
  end
  for _, tool in ipairs(tools) do
    local pkg = tool:mason_package()
    if pkg ~= nil then
      result[#result + 1] = pkg
    end
  end
  return result
end

return {
  mason_packages = collect_mason_packages(all_servers, all_formatters),
  all_servers = all_servers,
  all_formatters = all_formatters,
}
