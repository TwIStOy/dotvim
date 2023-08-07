local M = {}

---@class FunctionSet
---@field filter fun(VimBuffer):boolean
---@field functions FunctionWithDescription[]
local FunctionSet = {}

---@param buffer VimBuffer
function FunctionSet:match(buffer)
  return self.filter(buffer)
end

---@type FunctionSet[]
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

---@param title string
---@param cmd string
---@return table
function M.t_cmd(title, cmd)
  return {
    title = title,
    f = function()
      vim.cmd(cmd)
    end,
  }
end

---@class AddFunctionSetOptions
---@field category string|nil
---@field functions FunctionWithDescription[]
---@field ft string|string[]|nil
---@field filename string|string[]|nil
---@field filter nil|fun(VimBuffer):boolean
local AddFunctionSetOptions = {}

---@param opts AddFunctionSetOptions
function M:add_function_set(opts)
  local normalize = require("ht.utils.table").normalize_search_table

  local category = opts.category

  ---@param buffer VimBuffer
  local filter = function(buffer)
    local ft = normalize(opts.ft)
    local filename = normalize(opts.filename)
    local filter = opts.filter
    return (ft == nil or ft[buffer.filetype])
      and (filename == nil or filename[buffer.filename])
      and (filter == nil or filter(buffer))
  end

  local function_set = {
    filter = filter,
    functions = opts.functions,
  }
  for _, function_ in ipairs(function_set.functions) do
    if function_.category == nil then
      function_.category = category
    end
  end
  setmetatable(function_set, { __index = FunctionSet })
  table.insert(M.functions, function_set)
  M.cache:clear()
end

---@param bufnr number
---@return FunctionWithDescription[], number, number
function M:get_functions(bufnr)
  local buffer = require("ht.core.vim.buffer")(bufnr)
  ---@type any[]
  local cache_key = buffer:to_cache_key()
  -- global states
  local status, retval = pcall(function()
    return require("trouble").is_open()
  end)
  local trouble_is_open = status and retval
  cache_key[#cache_key + 1] = trouble_is_open
  local res = M.cache:ensure(cache_key, function()
    local res = {}
    for _, function_set in ipairs(M.functions) do
      if function_set:match(buffer) then
        vim.list_extend(res, function_set.functions)
      end
    end
    local category_width, title_width = calculate_width(res)
    return { res, category_width, title_width }
  end)
  return unpack(res)
end

return M
