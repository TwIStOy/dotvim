---@type dora.lib
local lib = require("dora.lib")

---@type dora.core.package.PackageOption
return {
  name = "dora.packages.lsp",
  deps = {
    "dora.packages.coding",
  },
  plugins = lib.tbl.flatten_array {
    require("dora.packages.lsp.plugins.nvim-lspconfig"),
    require("dora.packages.lsp.plugins.lspkind"),
    require("dora.packages.lsp.plugins.glance"),
  },
  setup = function()
    ---@type dora.config.lsp
    local lsp = require("dora.config.lsp")

    ---@param buffer number
    local function create_lsp_autocmds(buffer)
      -- display diagnostic win on CursorHold
      vim.api.nvim_create_autocmd("CursorHold", {
        buffer = buffer,
        callback = lsp.methods.open_diagnostic,
      })
    end

    ---@param buffer? number
    local function setup_lsp_keymaps(buffer)
      ---comment normal map
      ---@param lhs string
      ---@param rhs any
      ---@param desc string
      local nmap = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = buffer })
      end

      nmap("gD", lsp.methods.declaration, "goto-declaration")

      nmap("gd", lsp.methods.definitions, "goto-definition")

      nmap("gt", lsp.methods.type_definitions, "goto-type-definition")

      if buffer ~= nil then
        local current_k_map = vim.fn.mapcheck("K", "n")
        -- empty or contains "nvim/runtime"
        if current_k_map == "" or current_k_map:find("nvim/runtime") ~= nil then
          nmap("K", lsp.methods.show_hover, "show-hover")
        end
      else
        nmap("K", lsp.methods.show_hover, "show-hover")
      end

      nmap("gi", lsp.methods.implementations, "goto-impl")

      nmap("gR", lsp.methods.rename, "rename-symbol")

      nmap("ga", lsp.methods.code_action, "code-action")

      nmap("gr", lsp.methods.references, "inspect-references")

      nmap("[c", lsp.methods.prev_diagnostic, "previous-diagnostic")

      nmap("]c", lsp.methods.next_diagnostic, "next-diagnostic")
    end

    -- if in vscode environment, create key bindings globally, else only create
    -- keybindings on lsp enabled buffers
    if vim.g.vscode then
      setup_lsp_keymaps()
    else
      lib.vim.on_lsp_attach(function(_, buffer)
        local exists, value =
          pcall(vim.api.nvim_buf_get_var, buffer, "_dora_lsp_attached")
        if not exists or not value then
          create_lsp_autocmds(buffer)
          setup_lsp_keymaps(buffer)
          vim.api.nvim_buf_set_var(buffer, "_dora_lsp_attached", true)
        end
      end)
    end
  end,
}
