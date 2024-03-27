---@class dotvim.utils.nix
local M = {}

---@type dotvim.utils.fn
local fn = require("dotvim.utils.fn")
---@type dotvim.utils.fs
local fs = require("dotvim.utils.fs")

---@type fun():string[]
local get_plugin_packages = fn.invoke_once(function()
  local obj = vim
    .system(
      { "nix-store", "--query", "--requisites", "/run/current-system" },
      { text = true }
    )
    :wait()
  if obj.code == 0 then
    ---@type string[]
    local lines = vim.split(obj.stdout or "", "\n", { trimempty = true })
    local res = {}
    for _, value in ipairs(lines) do
      if value:find("vimplugin-") then
        res[#res + 1] = value
      end
    end
    return res
  else
    return {}
  end
end)

function M.update_nix_plugin_packages()
  local packages = get_plugin_packages()
  fs.write_file(
    vim.fn.stdpath("data") .. "/nix-plugin-packages",
    table.concat(packages, "\n")
  )
end

return M
