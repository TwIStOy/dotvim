local telescope = require("telescope")

---@type dotvim.extra.obsidian.telescope
local Extra = require("dotvim.extra.obsidian.telescope")

---@diagnostic disable-next-line: undefined-field
return telescope.register_extension {
  exports = {
    find_notes_by_alias = Extra.find_notes_alias,
    find_notes_by_tags = Extra.find_notes_tags,
  },
}
