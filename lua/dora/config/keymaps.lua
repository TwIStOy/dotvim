return function()
  local lsp = require("dora.config.lsp")

  -- lsp keymaps
  vim.keymap.set(
    "n",
    "gd",
    lsp.definitions,
    { noremap = true, silent = true, desc = "goto-definitions" }
  )
  vim.keymap.set(
    "n",
    "gD",
    lsp.declaration,
    { noremap = true, silent = true, desc = "goto-declarations" }
  )
  vim.keymap.set(
    "n",
    "gt",
    lsp.type_definitions,
    { noremap = true, silent = true, desc = "goto-type-definitions" }
  )
  vim.keymap.set(
    "n",
    "gi",
    lsp.implementations,
    { noremap = true, silent = true, desc = "goto-implementations" }
  )
  vim.keymap.set(
    "n",
    "gR",
    lsp.rename,
    { noremap = true, silent = true, desc = "rename-symbol" }
  )
  vim.keymap.set(
    "n",
    "ga",
    lsp.code_action,
    { noremap = true, silent = true, desc = "code-action" }
  )
  vim.keymap.set(
    "n",
    "gr",
    lsp.references,
    { noremap = true, silent = true, desc = "inspect-references" }
  )
  vim.keymap.set(
    "n",
    "[c",
    lsp.prev_diagnostic,
    { noremap = true, silent = true, desc = "previous-diagnostic" }
  )
  vim.keymap.set(
    "n",
    "]c",
    lsp.next_diagnostic,
    { noremap = true, silent = true, desc = "next-diagnostic" }
  )
  vim.keymap.set(
    "n",
    "K",
    lsp.show_hover,
    { noremap = true, silent = true, desc = "show-hover-doc" }
  )
end
