---@class dotvim.utils.ansi
local M = {}

local RESET_CODE = "\x1b[0m"
local RGB_FOREGROUND = "\x1b[38;2;%d;%d;%dm"
local RGB_BACKGROUND = "\x1b[48;2;%d;%d;%dm"
local RGB_UNDERLINE = "\x1b[58;2;%d;%d;%dm"
local EFFECT_BOLD = "\x1b[1m"
local EFFECT_ITALIC = "\x1b[3m"
local EFFECT_UNDERLINE = "\x1b[4m"
local EFFECT_INVERSE = "\x1b[7m"
local EFFECT_STRIKETHROUGH = "\x1b[9m"

local hl_def_codes = {
  fg = RGB_FOREGROUND,
  bg = RGB_BACKGROUND,
  sp = RGB_UNDERLINE,
  bold = EFFECT_BOLD,
  italic = EFFECT_ITALIC,
  underline = EFFECT_UNDERLINE,
  undercurl = EFFECT_UNDERLINE,
  underdouble = EFFECT_UNDERLINE,
  underdotted = EFFECT_UNDERLINE,
  underdashed = EFFECT_UNDERLINE,
  strikethrough = EFFECT_STRIKETHROUGH,
  reverse = EFFECT_INVERSE,
}

---@param value number
---@return number, number, number
local function split_rgb(value)
  local r = value / 65536
  local g = (value % 65536) / 256
  local b = value % 256
  return r, g, b
end

local code_cache = require("dora.lib").func.new_cache_manager()

---@param name string
---@return string?
local get_nvim_hl_code = function(name)
  return code_cache:ensure(name, function()
    local ok, group = pcall(vim.api.nvim_get_hl, 0, {
      name = name,
      create = false,
    })
    if not ok then
      return nil
    end
    local parts = {}
    for k, v in pairs(hl_def_codes) do
      local value = group[k]
      if value ~= nil then
        if type(value) == "number" then
          local r, g, b = split_rgb(value)
          parts[#parts + 1] = v:format(r, g, b)
        elseif value == true then
          parts[#parts + 1] = v
        end
      end
    end
    return table.concat(parts, "")
  end)
end

---@param str string
---@param hl? string
function M.wrap_str(str, hl)
  if hl == nil then
    return str
  end

  local hl_code = get_nvim_hl_code(hl)
  if hl_code == nil then
    return str
  end
  return hl_code .. str .. RESET_CODE
end

return M
