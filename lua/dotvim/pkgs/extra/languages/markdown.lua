---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.markdown",
  deps = {
    "coding",
    "lsp",
    "editor",
    "treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "mermaid" })
        end
      end,
    },
    {
      "jbyuki/nabla.nvim",
      ft = { "latex", "markdown" },
      keys = {
        {
          "<leader>pf",
          function()
            require("nabla").popup {
              border = "solid",
            }
          end,
          ft = { "latex", "markdown" },
        },
      },
    },
    {
      "iamcco/markdown-preview.nvim",
      name = "markdown-preview.nvim",
      ft = { "markdown" },
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      init = function()
        vim.g.mkdp_open_to_the_world = true
        vim.g.mkdp_echo_preview_url = true
      end,
      actions = function()
        ---@type dotvim.core.action
        local action = require("dotvim.core.action")

        return action.make_options {
          from = "markdown-preview.nvim",
          category = "MdPreview",
          condition = function(buf)
            return buf.filetype == "markdown"
          end,
          actions = {
            {
              id = "markdown-preview.start",
              title = "Start md preview",
              callback = function()
                vim.api.nvim_command("MarkdownPreview")
              end,
            },
            {
              id = "markdown-preview.stop",
              title = "Stop md preview",
              callback = function()
                vim.api.nvim_command("MarkdownPreviewStop")
              end,
            },
            {
              id = "markdown-preview.toggle",
              title = "Toggle md preview",
              callback = function()
                vim.api.nvim_command("MarkdownPreviewToggle")
              end,
            },
          },
        }
      end,
    },
    {
      "dhruvasagar/vim-table-mode",
      ft = { "markdown" },
      cmd = { "TableModeEnable", "TableModeDisable" },
      gui = "all",
      actions = function()
        ---@type dotvim.core.action
        local action = require("dotvim.core.action")

        return action.make_options {
          from = "vim-table-mode",
          category = "TableMode",
          condition = function(buf)
            return buf.filetype == "markdown"
          end,
          actions = {
            {
              id = "table-mode.enable",
              title = "Enable table mode",
              callback = function()
                vim.api.nvim_command("TableModeEnable")
              end,
            },
            {
              id = "table-mode.disable",
              title = "Disable table mode",
              callback = function()
                vim.api.nvim_command("TableModeDisable")
              end,
            },
          },
        }
      end,
    },
    {
      "MeanderingProgrammer/markdown.nvim",
      name = "render-markdown",
      ft = { "markdown" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {},
      config = function(_, opts)
        require("render-markdown").setup(opts)
      end,
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          markdown = { "prettier" },
        },
      },
    },
  },
}
