---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--background-index",
    "--background-index-priority=normal",
    "--ranking-model=decision_forest",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--limit-references=100",
    "--include-cleaner-stdlib",
    "--all-scopes-completion",
    "-j=20",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
}
