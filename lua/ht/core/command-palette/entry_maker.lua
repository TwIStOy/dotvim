---@class ht.command_palette.TelescopeEntryOpt
---@field category string
---@field title string
---@field keys string?
---@field description string?
---@field original string
---@field action fun()

---@class ht.command_palette.TelescopeEntry: ht.command_palette.TelescopeEntryOpt
---@field display fun(entry: ht.command_palette.TelescopeEntryOpt):table

---@param category_width number
---@param title_width number
---@param keys_width number
---@return function
local function entry_maker(category_width, title_width, keys_width)
  local entry_display = require("telescope.pickers.entry_display")
  local displayer = entry_display.create {
    separator = " | ",
    items = {
      { width = category_width, right_justify = true },
      { width = title_width },
      { width = keys_width },
    },
  }

  ---@param entry ht.command_palette.TelescopeEntryOpt
  local function invoke_displayer(entry)
    return displayer {
      { entry.category, "@variable.builtin" },
      entry.title,
      entry.keys,
    }
  end

  ---@param entry ht.command_palette.TelescopeEntry
  return function(entry)
    local o = {
      display = invoke_displayer,
    }
    return vim.tbl_extend("error", entry, o)
  end
end

return entry_maker
