---@type dotvim.core.package.PackageOption
local M = {
  name = "lsp",
  deps = {
    "coding",
  },
  plugins = {
    require("dotvim.pkgs.lsp.plugins.nvim-lspconfig"),
    require("dotvim.pkgs.lsp.plugins.lspkind"),
    require("dotvim.pkgs.lsp.plugins.glance"),
    require("dotvim.pkgs.lsp.plugins.outline"),
    require("dotvim.pkgs.lsp.plugins.lsp-lines"),
    require("dotvim.pkgs.lsp.plugins.corn"),
    require("dotvim.pkgs.lsp.plugins.lsp-progress"),
    require("dotvim.pkgs.lsp.plugins.inline-diagnostic"),
  },
  setup = function()
    require("dotvim.extra.fswatch")()
  end,
}

local methods = require("dotvim.pkgs.lsp.methods")

---@type dotvim.core
local Core = require("dotvim.core")

---@param buffer number
local function create_lsp_autocmds(buffer)
  -- display diagnostic win on CursorHold
  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   buffer = buffer,
  --   callback = methods.open_diagnostic,
  -- })
  local inline_diag = require("dotvim.pkgs.lsp.methods.inline-diagnostic")

  vim.api.nvim_create_autocmd({ "CursorHold", "DiagnosticChanged" }, {
    buffer = buffer,
    callback = function()
      if vim.api.nvim_get_mode().mode == "i" then
        inline_diag.clear_inline_diagnostic()
      else
        inline_diag.render_inline_diagnostic()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    buffer = buffer,
    callback = function()
      inline_diag.clear_inline_diagnostic()
    end,
  })
end

---@param client? vim.lsp.Client
---@param buffer? number
local function setup_lsp_keymaps(client, buffer)
  ---comment normal map
  ---@param lhs string
  ---@param rhs any
  ---@param desc string
  local nmap = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = buffer })
  end

  nmap("gD", methods.declaration, "goto-declaration")

  nmap("gd", methods.definitions, "goto-definition")

  nmap("gt", methods.type_definitions, "goto-type-definition")

  if buffer ~= nil then
    local current_k_map = vim.fn.mapcheck("K", "n")
    -- empty or contains "nvim/runtime"
    if current_k_map == "" or current_k_map:find("nvim/runtime") ~= nil then
      nmap("K", methods.show_hover, "show-hover")
    end
  else
    nmap("K", methods.show_hover, "show-hover")
  end

  nmap("gi", methods.implementations, "goto-impl")

  nmap("gR", methods.rename, "rename-symbol")
  nmap("crn", methods.rename, "rename-symbol")

  nmap("ga", methods.code_action, "code-action")

  nmap("gr", methods.references, "inspect-references")

  nmap("[c", methods.prev_diagnostic, "previous-diagnostic")

  nmap("]c", methods.next_diagnostic, "next-diagnostic")

  local organize_imports = function() end
  local code_action_kinds = vim.F.if_nil(
    vim.tbl_get(
      vim.F.if_nil(client, {}),
      "server_capabilities",
      "codeActionProvider",
      "codeActionKinds"
    ),
    {}
  )
  if vim.list_contains(code_action_kinds, "source.organizeImports") then
    organize_imports = methods.organize_imports
  end
  nmap("<leader>fi", organize_imports, "organize-imports")
end

M.setup = function()
  ---@type dotvim.utils
  local Utils = require("dotvim.utils")

  if Utils.vim.get_keymap("n", "grr") ~= nil then
    -- remove default lsp keymaps
    vim.api.nvim_del_keymap("n", "grr")
    vim.api.nvim_del_keymap("n", "gra")
    vim.api.nvim_del_keymap("n", "grn")
  end

  -- if in vscode environment, create key bindings globally, else only create
  -- keybindings on lsp enabled buffers
  if vim.g.vscode then
    setup_lsp_keymaps()
  else
    Core.lsp.on_lsp_attach(function(client, buffer)
      local exists, value =
        pcall(vim.api.nvim_buf_get_var, buffer, "_dotvim_lsp_attached")
      if not exists or not value then
        create_lsp_autocmds(buffer)
        setup_lsp_keymaps(client, buffer)
        vim.api.nvim_buf_set_var(buffer, "_dotvim_lsp_attached", true)
      end
    end)
  end
end

return M
