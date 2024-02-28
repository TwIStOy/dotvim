---@type dora.core.plugin.PluginOption
return {
  "crusj/bookmarks.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },
  event = "BufReadPost",
  opts = {
    mappings_enabled = false,
    sign_icon = "",
    virt_pattern = {
      "*.dart",
      "*.cpp",
      "*.ts",
      "*.lua",
      "*.js",
      "*.c",
      "*.h",
      "*.cc",
      "*.hh",
      "*.hpp",
      "*.md",
      "*.rs",
      "*.toml",
    },
    fix_enable = true,
  },
  keys = {
    {
      "<leader>lm",
      "Telescope bookmarks",
      desc = "list-bookmarks",
      silent = true,
    },
  },
  config = function(_, opts)
    require("bookmarks").setup(opts)
    require("telescope").load_extension("bookmarks")
  end,
  actions = function()
    ---@type dora.core.action
    local action = require("dora.core.action")

    return action.make_options {
      from = "bookmarks.nvim",
      category = "Bookmarks",
      actions = {
        {
          id = "bookmarks.toggle-bookmarks",
          title = "Toggle bookmarks",
          callback = function()
            require("bookmarks").toggle_bookmarks()
          end,
          keys = { "<leader>bt", desc = "toggle-bookmarks", silent = true },
        },
        {
          id = "bookmarks.add-bookmark",
          title = "Add bookmark",
          callback = function()
            require("bookmarks").add_bookmarks()
          end,
          keys = { "<leader>ba", desc = "add-bookmark", silent = true },
        },
        {
          id = "bookmarks.delete-at-virt-line",
          title = "Delete bookmark at virt text line",
          callback = function()
            require("bookmarks.list").delete_on_virt()
          end,
          keys = { "<leader>bd", desc = "delete-at-virt-line", silent = true },
        },
        {
          id = "bookmarks.show-bookmark-desc",
          title = "Show bookmark desc",
          callback = function()
            require("bookmarks.list").show_desc()
          end,
          keys = { "<leader>bs", desc = "show-bookmark-desc", silent = true },
        },
      },
    }
  end,
}
