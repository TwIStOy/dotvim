---@class dora.config.icon
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
  LSPLoading1 = "",
  LSPLoading2 = "󰀚",
  LSPLoading3 = "",
  MacroRecording = "",
  Package = "󰏖",
  Paste = "󰅌",
  Refresh = "",
  Search = "",
  Selected = "❯",
  Session = "󱂬",
  Sort = "󰒺",
  Spellcheck = "󰓆",
  Tab = "󰓩",
  TabClose = "󰅙",
  Terminal = "",
  Window = "",
  WordFile = "󰈭",
  VimLogo = "",
}

---@param kind string
---@param padding? number
---@return string
function M.predefined_icon(kind, padding)
  local icon = M.icons[kind]
  if icon == nil then
    return ""
  end
  return icon .. string.rep(" ", padding or 0)
end

---@param opts table<string, string>
function M.setup(opts)
  M.icons = vim.tbl_extend("force", M.icons, opts)
end

return M
