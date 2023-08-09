local CoreConst = require("ht.core.const")
local UtilsTable = require("ht.utils.table")

---@class ht.external_tool.MasonPackageOpts
---@field name string
---@field version string?

---@class ht.external_tool.FromMason
---@field name string name of tool/lsp
---@field mason ht.MasonPackage|boolean|nil mason package opts, or false to disable
local from_mason = {}

---@return ht.external_tool.MasonPackageOpts?
function from_mason:mason_package()
  if self.mason == false then
    return nil
  end
  if self.mason == nil or self.mason == true then
    return { name = self.name }
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return self.mason
end

---@param exe string
---@return string
function from_mason:bin(exe)
  if self.mason == false then
    -- this package is not from mason, can not be get from mason_bin
    return exe
  end
  return CoreConst.mason_bin .. "/" .. exe
end

---@class ht.external_tool.formatter.ToolOpts
---@field args string[]?
---@field fname string|boolean?
---@field stdin boolean?
---@field timeout number?
---@field ignore_pattern table?
---@field ignore_error boolean?
---@field fn function?

---@class ht.external_tool.Formatter: ht.external_tool.FromMason
---@field ft string
---@field cmd string executable name
---@field opts ht.external_tool.formatter.ToolOpts
local formatter = {}

---@param ft string
---@param cmd string executable name
---@param opts ht.external_tool.formatter.ToolOpts
---@param mason_opts ht.external_tool.FromMason
---@return ht.external_tool.Formatter
function formatter.new(ft, cmd, opts, mason_opts)
  local o = {
    ft = ft,
    cmd = cmd,
    opts = opts,
  }
  if mason_opts ~= nil then
    o = vim.tbl_extend("error", o, mason_opts)
  end
  setmetatable(o, {
    __index = UtilsTable.make_index_function {
      formatter,
      from_mason,
    },
  })
  return o
end

function formatter:export_opts()
  local res = {
    cmd = self:bin(self.cmd),
  }
  res = vim.tbl_extend("error", res, self.opts)
  return res
end

return {
  from_mason = from_mason,
  formatter = formatter,
}
