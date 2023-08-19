---@param root string
local function box_meta(root)
  local module_meta = {
    __index = function(tbl, key)
      local name = ("%s.%s"):format(root, key)
      local module
      if pcall(function()
        module = require(name)
      end) then
        if type(module) == "table" then
          setmetatable(module, box_meta(name))
          rawset(tbl, key, module)
        elseif type(module) == "function" then
          local meta = box_meta(name)
          meta.__call = function(...)
            return module(...)
          end
          rawset(tbl, key, setmetatable({}, meta))
        else
          error("Module must returns a table or a function")
        end
      end
      return rawget(tbl, key)
    end,
  }
  return module_meta
end

return setmetatable({}, box_meta("ht"))
