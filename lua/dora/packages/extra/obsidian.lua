---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.obsidian",
  deps = {
    "dora.packages.editor",
    "dora.packages.coding",
  },
  setup = function()
    local au_group =
      vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })

    ---@type dora.lib
    local lib = require("dora.lib")

    local dir = vim.F.if_nil(
      lib.lazy.opts("obsidian.nvim").dir,
      vim.fn.expand("~/obsidian-data")
    )

    vim.api.nvim_create_autocmd(
      { "BufNewFile", "BufReadPost", "BufWinEnter" },
      {
        group = au_group,
        pattern = dir .. "/**.md",
        callback = function()
          vim.wo.conceallevel = 2
          vim.keymap.set("n", "gf", function()
            if require("obsidian").util.cursor_on_markdown_link() then
              vim.api.nvim_command("ObsidianFollowLink")
            end
          end, { buffer = true, desc = "obsidian-follow-link" })
        end,
      }
    )
  end,
  plugins = {
    {
      "epwalsh/obsidian.nvim",
      version = "*",
      ft = "markdown",
      dependencies = {
        "plenary.nvim",
        "telescope.nvim",
        "nvim-treesitter",
      },
      cmd = {
        "ObsidianBacklinks",
        "ObsidianExtractNote",
        "ObsidianFollowLink",
        "ObsidianLink",
        "ObsidianLinkNew",
        "ObsidianLinks",
        "ObsidianNew",
        "ObsidianOpen",
        "ObsidianPasteImg",
        "ObsidianQuickSwitch",
        "ObsidianRename",
        "ObsidianSearch",
        "ObsidianTags",
        "ObsidianTemplate",
        "ObsidianToday",
        "ObsidianTomorrow",
        "ObsidianWorkspace",
        "ObsidianYesterday",
      },
      opts = {},
    },
  },
}
