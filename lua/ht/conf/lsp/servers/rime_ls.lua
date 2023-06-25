local Const = require("ht.core.const")

---@type ht.LspConf
local M = {}

M.name = "rime_ls"

M.mason_pkg = false

M.setup = function(on_attach, capabilities)
  local rime = require("ht.plugrc.lsp.custom.rime")
  rime.setup()
  require("lspconfig").rime_ls.setup {
    cmd = vim.g.rime_ls_cmd,
    init_options = {
      enabled = false,
      shared_data_dir = "/usr/share/rime-data",
      user_data_dir = "~/.local/share/rime-ls",
      log_dir = "~/.local/share/rime-ls/log",
      max_candidates = 9,
      trigger_characters = {},
      schema_trigger_character = "&",
      max_tokens = 4,
      override_server_capabilities = { trigger_characters = {} },
      always_incomplete = true,
    },
    on_attach = on_attach,
    --- update capabilities???
    capabilities = capabilities,
  }
end

return M
