---@type ht.LspConf
local M = {}

M.args = {}

M.settings = {
  ["rust-analyzer"] = {
    cargo = { buildScripts = { enable = true } },
    procMacro = { enable = true },
    check = {
      command = "clippy",
      extraArgs = { "--all", "--", "-W", "clippy::all" },
    },
    completion = { privateEditable = { enable = true } },
    diagnostic = {
      enable = true,
      disabled = { "inactive-code" },
    },
  },
}

return M
