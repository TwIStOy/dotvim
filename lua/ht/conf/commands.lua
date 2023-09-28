local function setup()
  local cfg = {
    layout_strategy = "center",
    sorting_strategy = "ascending",
    layout_config = {
      anchor = "N",
      width = 0.5,
      prompt_position = "top",
      height = 0.5,
    },
    border = true,
    results_title = false,
    -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }

  vim.api.nvim_create_user_command("ObsidianSearchByAlias", function()
    require("telescope").extensions.obsidian.find_notes_by_alias(cfg)
  end, {
    force = true,
    desc = "Search Obsidian by alias",
  })
  vim.api.nvim_create_user_command("ObsidianSearchByTags", function()
    require("telescope").extensions.obsidian.find_notes_by_tags(cfg, cfg)
  end, {
    force = true,
    desc = "Search Obsidian by tags",
  })
end

return {
  setup = setup,
}
