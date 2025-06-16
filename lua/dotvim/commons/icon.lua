-- Icon utilities for new-style config
local M = {}

M.icons = {
  ActiveLSP = "",
  ActiveTS = "",
  ArrowLeft = "",
  ArrowRight = "",
  Bookmarks = "",
  BufferClose = "󰅖",
  DapBreakpoint = "",
  DapBreakpointCondition = "",
  DapBreakpointRejected = "",
  DapLogPoint = ".>",
  DapStopped = "󰁕",
  Debugger = "",
  DefaultFile = "",
  Diagnostic = "󰒡",
  DiagnosticError = "",
  DiagnosticHint = "󰌵",
  DiagnosticInfo = "󰋼",
  DiagnosticWarn = "",
  Ellipsis = "…",
  FileNew = "",
  FileModified = "",
  FileReadOnly = "",
  FoldClosed = "",
  FoldOpened = "",
  FoldSeparator = " ",
  FolderClosed = "",
  FolderEmpty = "",
  FolderOpen = "",
  Git = "󰊢",
  GitAdd = "",
  GitBranch = "",
  GitChange = "",
  GitConflict = "",
  GitDelete = "",
  GitIgnored = "◌",
  GitRenamed = "➜",
  GitSign = "▎",
  GitStaged = "✓",
  GitUnstaged = "✗",
  GitUntracked = "★",
  LSPLoaded = "",
}

-- Get predefined icon with optional padding
---@param kind string The icon name
---@param padding? number Number of spaces to add after the icon
---@return string
function M.get(kind, padding)
  local icon = M.icons[kind]
  if icon == nil then
    return ""
  end
  return icon .. string.rep(" ", padding or 0)
end

-- Get icon without padding (for direct use)
---@param kind string The icon name
---@return string
function M.icon(kind)
  return M.icons[kind] or ""
end

-- Setup function to extend icons
---@param opts table<string, string> Custom icons to add or override
function M.setup(opts)
  M.icons = vim.tbl_extend("force", M.icons, opts or {})
end

return M
