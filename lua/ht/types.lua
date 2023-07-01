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
