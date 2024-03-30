---@type dotvim.core.package.PackageOption
local M = {
  name = "lsp",
  plugins = {
    require("dotvim.pkgs.lsp.plugins.nvim-lspconfig"),
    require("dotvim.pkgs.lsp.plugins.lspkind"),
    require("dotvim.pkgs.lsp.plugins.glance"),
    require("dotvim.pkgs.lsp.plugins.aerial"),
  },
}

local methods = require("dotvim.core.lsp.methods")

---@type dotvim.core
local Core = require("dotvim.core")

---@param buffer number
local function create_lsp_autocmds(buffer)
  -- display diagnostic win on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = buffer,
    callback = methods.open_diagnostic,
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

  nmap("ga", methods.code_action, "code-action")

  nmap("gr", methods.references, "inspect-references")

  nmap("[c", methods.prev_diagnostic, "previous-diagnostic")

  nmap("]c", methods.next_diagnostic, "next-diagnostic")
end

M.setup = function()
  -- if in vscode environment, create key bindings globally, else only create
  -- keybindings on lsp enabled buffers
  if vim.g.vscode then
    setup_lsp_keymaps()
  else
    Core.lsp.on_lsp_attach(function(_, buffer)
      local exists, value =
        pcall(vim.api.nvim_buf_get_var, buffer, "_dotvim_lsp_attached")
      if not exists or not value then
        create_lsp_autocmds(buffer)
        setup_lsp_keymaps(buffer)
        vim.api.nvim_buf_set_var(buffer, "_dotvim_lsp_attached", true)
      end
    end)
  end
end

return M