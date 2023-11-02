local icons = {
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
}

local function get_icon(kind, padding)
  local icon = icons[kind]
  if icon == nil then
    return ""
  end
  return icon .. string.rep(" ", padding or 0)
end

return {
  get_icon = get_icon,
}