---@type ht.LspConf[]
local all_servers = (function()
  local confs = {}
  confs[#confs + 1] = require("ht.conf.lsp.servers.clangd")
  confs[#confs + 1] = require("ht.conf.lsp.servers.rust-analyzer")
  confs[#confs + 1] = require("ht.conf.lsp.servers.pyright")
  confs[#confs + 1] = require("ht.conf.lsp.servers.cmake")
  confs[#confs + 1] = require("ht.conf.lsp.servers.lua_ls")
  confs[#confs + 1] = require("ht.conf.lsp.servers.rime_ls")
  confs[#confs + 1] = require("ht.conf.lsp.servers.tsserver")

  -- init sourcekit in macos
  if vim.fn.has("macunix") then
    confs[#confs + 1] = require("ht.conf.lsp.servers.sourcekit")
  end

  return confs
end)()

---@param confs ht.LspConf[]
---@return string[]
local function collect_mason_packages(confs)
  local result = {}
  for _, conf in ipairs(confs) do
    if conf.mason_pkg == nil then
      result[#result + 1] = conf.mason_pkg
    elseif conf.mason_pkg ~= false then
      result[#result + 1] = conf.name
    end
  end
  return result
end

return {
  mason_packages = collect_mason_packages(all_servers),
  all_servers = all_servers,
}
