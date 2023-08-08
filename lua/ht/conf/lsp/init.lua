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
  confs[#confs + 1] = require("ht.conf.lsp.servers.grammarly")

  -- init sourcekit in macos
  if vim.fn.has("macunix") then
    confs[#confs + 1] = require("ht.conf.lsp.servers.sourcekit")
  end

  return confs
end)()

---@type ht.LspTool[]
local all_tools = (function()
  return {
    {
      name = "clang_format",
      mason_pkg = "clang-format",
      typ = "formatting",
    },
    {
      name = "stylua",
      typ = "formatting",
      opts = {
        condition = function(utils)
          return utils.root_has_file { "stylua.toml", ".stylua.toml" }
        end,
      },
    },
    {
      name = "rustfmt",
      mason_pkg = false,
      typ = "formatting",
    },
    {
      name = "prettier",
      typ = "formatting",
    },
    {
      name = "black",
      typ = "formatting",
    },
  }
end)()

---@param confs ht.LspConf[]
---@param tools ht.LspTool[]
---@return ht.MasonPackage[]
local function collect_mason_packages(confs, tools)
  local result = {}
  for _, conf in ipairs(confs) do
    if conf.mason_pkg == nil then
      result[#result + 1] = {
        name = conf.name,
      }
    elseif conf.mason_pkg ~= false then
      result[#result + 1] = {
        name = conf.mason_pkg,
        version = conf.mason_version,
      }
    end
  end
  for _, tool in ipairs(tools) do
    if tool.mason_pkg == nil then
      result[#result + 1] = { name = tool.name }
    elseif tool.mason_pkg ~= false then
      result[#result + 1] = {
        name = tool.mason_pkg,
        version = tool.mason_version,
      }
    end
  end
  return result
end

return {
  mason_packages = collect_mason_packages(all_servers, all_tools),
  all_servers = all_servers,
  all_tools = all_tools,
}
