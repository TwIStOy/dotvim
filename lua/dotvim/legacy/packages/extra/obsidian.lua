local vault_dir = function()
  ---@type dora.lib
  local lib = require("dora.lib")
  return vim.F.if_nil(
    lib.lazy.opts("obsidian.nvim").dir,
    vim.fn.expand("~/obsidian-data")
  )
end

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

    vim.api.nvim_create_autocmd(
      { "BufNewFile", "BufReadPost", "BufWinEnter" },
      {
        group = au_group,
        pattern = vault_dir() .. "/**.md",
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
      event = function()
        return {
          ("BufReadPre %s/*.md"):format(vault_dir()),
          ("BufNewFile %s/*.md"):format(vault_dir()),
        }
      end,
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
