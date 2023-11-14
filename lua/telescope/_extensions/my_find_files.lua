local telescope = require("telescope")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")

local find_files = function(opts)
  local live_fd = finders.new_job(function(prompt)
    return vim.tbl_flatten { "fd", "--type", "f", "--color", "never", prompt }
  end, opts.entry_maker or make_entry.gen_from_file(opts))

  pickers
    .new(opts, {
      prompt_title = "Find Files",
      finder = live_fd,
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return telescope.register_extension {
  exports = { my_find_files = find_files },
}

