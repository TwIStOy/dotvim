local UtilsTable = require("ht.utils.table")
local CoreExternalTool = require("ht.core.external_tool")

---@class ht.lsp.ServerOpts: ht.external_tool.FromMason
---@field right_click NewSectionOptions[]|nil
---@field function_sets AddFunctionSetOptions[]|nil
---@field setup nil|fun(on_attach: function, capabilities: table): any

---@class ht.lsp.Server: ht.lsp.ServerOpts
local server = {}

---@param opts ht.lsp.ServerOpts
---@return ht.lsp.Server
function server.new(opts)
  local o = {}
  o = vim.tbl_extend("force", o, opts)
  setmetatable(o, {
    __index = UtilsTable.make_index_function {
      server,
      CoreExternalTool.from_mason,
    },
  })
  return o
end

return server
