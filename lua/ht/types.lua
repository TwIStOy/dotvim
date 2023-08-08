---@class ht.LspConf
---@field name string name of server, used for lspconfig
---@field mason_pkg string|boolean|nil
---@field mason_version string|nil
---@field right_click NewSectionOptions[]|nil
---@field function_sets AddFunctionSetOptions[]|nil
---@field setup fun(on_attach: function, capabilities: table): any|nil

---@class ht.LspTool
---@field name string name of tool, used for null-ls
---@field mason_pkg string|boolean|nil
---@field typ string "formatting"|"diagnostics"|"code_actions"|"completion"|"hover"
---@field opts table|nil

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

