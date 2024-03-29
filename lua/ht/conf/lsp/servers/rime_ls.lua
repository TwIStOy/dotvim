local CoreLspServer = require("ht.core.lsp.server")

---@type ht.lsp.ServerOpts
local opts = {}

opts.name = "rime_ls"

opts.mason = false

vim.g.global_rime_enabled = false

local function rime_on_attach(client, bufnr)
  local toggle_rime = function()
    client.request(
      "workspace/executeCommand",
      { command = "rime-ls.toggle-rime" },
      function(_, result, ctx, _)
        if ctx.client_id == client.id then
          vim.g.global_rime_enabled = result
        end
      end
    )
  end

  vim.keymap.set({ "n", "i" }, "<M-;>", function()
    toggle_rime()
  end, { silent = true, desc = "rime-toggle", buffer = bufnr })

  if vim.api.nvim_buf_get_option(bufnr, "ft") == "markdown" then
    local toggle_markdown_code = function()
      if vim.g.previous_markdown_code ~= nil then
        if vim.g.previous_markdown_code ~= vim.g.global_rime_enabled then
          toggle_rime()
        end
        vim.g.previous_markdown_code = nil
      else
        vim.g.previous_markdown_code = vim.g.global_rime_enabled
        if vim.g.global_rime_enabled then
          toggle_rime()
        end
      end
    end

    vim.keymap.set({ "i" }, "`", function()
      toggle_markdown_code()
      vim.fn.feedkeys("`", "n")
    end, { silent = true, desc = "rime-toggle", buffer = bufnr })
  end

  vim.keymap.set("n", "<leader>rs", function()
    vim.lsp.buf.execute_command { command = "rime-ls.sync-user-data" }
  end, { desc = "rime-sync-user-data", buffer = bufnr })
end

local function wrap_attach(on_attach)
  return function(client, bufnr)
    on_attach(client, bufnr)
    rime_on_attach(client, bufnr)
  end
end

opts.setup = function(on_attach, capabilities)
  local configs = require("lspconfig.configs")
  if not configs.rime_ls then
    configs.rime_ls = {
      default_config = {
        name = "rime_ls",
        cmd = { "rime_ls" },
        filetypes = { "markdown", "txt" },
        single_file_support = true,
      },
      settings = {},
      docs = {
        description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
      },
    }
  end

  require("lspconfig").rime_ls.setup {
    cmd = { "rime_ls" },
    -- cmd = { "socat", "tcp:127.0.0.1:9257", "-" },
    init_options = {
      enabled = false,
      shared_data_dir = "~/.local/share/rime-ls-data-files",
      user_data_dir = "~/.local/share/rime-ls-files",
      log_dir = "~/.local/share/rime-ls-files/log",
      max_candidates = 9,
      trigger_characters = {},
      schema_trigger_character = "&",
      max_tokens = 4,
      override_server_capabilities = { trigger_characters = {} },
      always_incomplete = true,
    },
    on_attach = wrap_attach(on_attach),
    capabilities = capabilities,
  }
end

return CoreLspServer.new(opts)
