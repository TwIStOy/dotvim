---@class dotvim.extra.hydra.utils
local M = {}

---@param opts hydra.Head|string|function
---@return hydra.Head
function M.normalize_head(opts)
  if type(opts) == "string" then
    return { opts, {} }
  elseif type(opts) == "function" then
    return { nil, { body = opts } }
  else
    return opts
  end
end

---@param opts table<string, hydra.Head|string|function>
---@return table[]
function M.normalize_heads(opts)
  local ret = {}
  for key, opt in pairs(opts) do
    ret[#ret + 1] = { key, unpack(M.normalize_head(opt)) }
  end
  return ret
end

return M
