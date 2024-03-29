---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.markdown",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
    "dora.packages.treesitter",
  },
  plugins = {
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
        ---@type dora.core.action
        local action = require("dora.core.action")

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
        ---@type dora.core.action
        local action = require("dora.core.action")

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
      "lukas-reineke/headlines.nvim",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      enabled = function()
        return not vim.g.neovide
      end,
      ft = { "markdown", "vimwiki" },
      opts = {},
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
