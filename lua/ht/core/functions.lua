local M = {}

---@class FunctionWithDescription
---@field f function
---@field title string
---@field category string|nil
---@field description string
local FunctionWithDescription = {}

---@class FunctionSetOptions
---@field filetype string|table|nil
---@field filename string|table|nil
---@field functions FunctionWithDescription[]
local FunctionSetOptions = {}

function FunctionSetOptions:match(ft, filename)
  if self.filetype ~= nil then
    if type(self.filetype) == "string" then
      if ft ~= self.filetype then
        return false
      end
      ---@diagnostic disable-next-line: param-type-mismatch
    elseif
      type(self.filetype) == "table" and vim.tbl_isarray(self.filetype)
    then
      ---@diagnostic disable-next-line: param-type-mismatch
      if not vim.list_contains(self.filetype, ft) then
        return false
      end
    end
  end
  if self.filename ~= nil then
    if type(self.filename) == "string" then
      if filename ~= self.filename then
        return false
      end
      ---@diagnostic disable-next-line: param-type-mismatch
    elseif
      type(self.filename) == "table" and vim.tbl_isarray(self.filename)
    then
      ---@diagnostic disable-next-line: param-type-mismatch
      if not vim.list_contains(self.filename, filename) then
        return false
      end
    end
  end

  return true
end

---@type FunctionSetOptions[]
M.functions = {}
M.cache = require("ht.utils.cache").new()

---@param functions FunctionWithDescription[]
local function calculate_width(functions)
  local category = 0
  local title = 0
  for _, function_ in ipairs(functions) do
    if function_.category == nil then
      function_.category = ""
    end
    category = math.max(category, #function_.category)
    title = math.max(title, #function_.title)
  end
  return category, title
end

function M.t_cmd(title, cmd)
  return {
    title = title,
    f = function()
      vim.cmd(cmd)
    end,
  }
end

function M:add_function_set(opts)
  local category = opts.category
  local function_set = {
    filetype = opts.filetype,
    filename = opts.filename,
    functions = opts.functions,
  }
  for _, function_ in ipairs(function_set.functions) do
    if function_.category == nil then
      function_.category = category
    end
  end
  setmetatable(function_set, { __index = FunctionSetOptions })
  table.insert(M.functions, function_set)
  M.cache:clear()
end

---@param ft string
---@param filename string
---@return FunctionWithDescription[], number, number
function M:get_functions(ft, filename)
  local res = M.cache:ensure({ ft, filename }, function()
    local res = {}
    for _, function_set in ipairs(M.functions) do
      if function_set:match(ft, filename) then
        vim.list_extend(res, function_set.functions)
      end
    end
    local category_width, title_width = calculate_width(res)
    return { res, category_width, title_width }
  end)
  return unpack(res)
end

return M
