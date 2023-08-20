---@class ht.tool.ToolBase
---@field name string

---@class ht.tool.Formatter
---@field name string
---@field mason ht.MasonPackage?
---@field opts table?

---@class ht.MasonPackage
---@field name string
---@field version string|nil

---@class FunctionWithDescription
---@field f function
---@field title string
---@field category string|nil
---@field description string

---@class vim.AutocmdCallback.Event
---@field id number autocommand id
---@field event string name of the triggered event
---@field group number? autocommand group id, if any
---@field match string expanded value of <amatch>
---@field buf number expanded value of <abuf>
---@field file string expanded value of <afile>
---@field data any arbitrary data passed from `nvim_exec_autocmds()`

---@class ht.lsp.WorkspaceSymbolsOptions
---@field top_level_only boolean?

---@class ht.lsp.DocumentSymbolsOptions
---@field winnr number?
---@field bufnr number?

---@class ht.lsp.WorkspaceAndDocumentSymbolsOptions
---@field winnr number?
---@field bufnr number?
---@field top_level_only boolean?
---@field entry_maker function?
---@field query string?

---@class ht.lsp.SymbolInformation
---@field filename string
---@field lnum number
---@field col number
---@field kind string
---@field text string the name of this symbol
---@field detail string? more detail for this symbol, e.g the signature of a function.

---@class ht.CursorPosition
---@field [1] number
---@field [2] number
