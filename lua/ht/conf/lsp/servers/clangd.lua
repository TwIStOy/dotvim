---@type ht.LspConf
local M = {}

M.args = {
  "--clang-tidy",
  "--background-index",
  "--background-index-priority=normal",
  "--ranking-model=decision_forest",
  "--completion-style=detailed",
  "--header-insertion=iwyu",
  "--limit-references=100",
  "--limit-results=100",
  "--include-cleaner-stdlib",
  "-j=20",
}

local function on_collect_mason_pkg()
  return "clangd"
end

return M
