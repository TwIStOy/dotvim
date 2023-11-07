local function setup()
  local cfg_at_top = {
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

  local cfg_big = {
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.6,
    },
  }

  vim.api.nvim_create_user_command("ObsidianSearchByAlias", function()
    require("telescope").extensions.obsidian.find_notes_by_alias(cfg_big)
  end, {
    force = true,
    desc = "Search Obsidian by alias",
  })
  vim.api.nvim_create_user_command("ObsidianSearchByTags", function()
    require("telescope").extensions.obsidian.find_notes_by_tags(
      cfg_at_top,
      cfg_big
    )
  end, {
    force = true,
    desc = "Search Obsidian by tags",
  })
end

return {
  setup = setup,
}
