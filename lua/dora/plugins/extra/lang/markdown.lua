local lib = require("dora.lib")

---@type dora.lib.PluginOptions[]
return {
  {
    "iamcco/markdown-preview.nvim",
    nixpkg = "markdown-preview-nvim",
    ft = { "markdown" },
    build = function()
      vim.api.nvim_command("call mkdp#util#install()")
    end,
    init = function()
      vim.g.mkdp_open_to_the_world = true
      vim.g.mkdp_echo_preview_url = true
    end,
    actions = lib.plugin.action.make_options {
      from = "markdown-preview.nvim",
      category = "MdPreview",
      ---@param buffer dora.lib.vim.Buffer
      condition = function(buffer)
        return buffer.filetype == "markdown"
      end,
      ---@type dora.lib.ActionOptions[]
      actions = {
        {
          id = "markdown-preview.start",
          title = "Start md preview",
          callback = "MarkdownPreview",
        },
        {

          id = "markdown-preview.stop",
          title = "Stop md preview",
          callback = "MarkdownPreviewStop",
        },
        {
          id = "markdown-preview.toggle",
          title = "Toggle md preview",
          callback = "MarkdownPreviewToggle",
        },
      },
    },
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(
          opts.ensure_installed,
          { "markdown", "markdown_inline" }
        )
      end
    end,
  },
}
