---@module "dotvim.plugins.base"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "xzbdmw/colorful-menu.nvim",
    enabled = not vim.g.vscode,
    opts = {
      max_width = 65,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts = {},
  },
  {
    "TwIStOy/luasnip-snippets",
    lazy = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      user = {
        name = "Hawtian Wang",
      },
      snippet = {
        lua = {
          vim_snippet = true,
        },
        rust = {
          rstest_support = true,
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "TwIStOy/luasnip-snippets",
    },
    opts = {
      enable_autosnippets = true,
      history = false,
      updateevents = "TextChanged,TextChangedI",
      region_check_events = {
        "CursorMoved",
        "CursorMovedI",
        "CursorHold",
      },
      cut_selection_keys = "<C-f>",
    },
    keys = {
      {
        "<C-e>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-b>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
      {
        "<C-f>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s", "n", "v" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = false,
    build = (function()
      if Commons.nix.in_nix_env() then
        return "nix run .#build-plugin"
      else
        return "cargo build --release"
      end
    end)(),
    enabled = not vim.g.vscode,
    opts_extend = { "sources.default" },
    opts = {
      fuzzy = {
        prebuilt_binaries = {
          download = false,
        },
      },
      keymap = {
        preset = "none",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        -- use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      cmdline = {
        enabled = false,
      },
      sources = {
        default = { "lsp", "buffer", "snippets" },
      },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
        menu = {
          scrolloff = 2,
          scrollbar = true,
          border = "none",
          draw = {
            gap = 1,
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            align_to = "label",
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  return ctx.kind_icon .. " " .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  return ctx.kind_hl
                end,
              },
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(
                    ctx
                  )
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = "single",
            -- winhighlight = "FloatBorder:FloatBorder",
            scrollbar = true,
          },
        },
      },
      signature = { enabled = true },
    },
  },
  {
    "stevearc/conform.nvim",
    enabled = not vim.g.vscode,
    keys = {
      {
        "<leader>fc",
        function()
          local conform = require("conform")
          conform.format {
            async = true,
            lsp_fallback = true,
          }
        end,
        desc = "format-file",
        mode = { "n", "v" },
      },
    },
    opts = {
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
      },
    },
    config = function(_, opts)
      local used_formatters = {}
      for _, value in pairs(opts.formatters_by_ft) do
        if type(value) == "string" then
          used_formatters[#used_formatters + 1] = value
        elseif type(value) == "table" then
          vim.list_extend(used_formatters, value)
        end
      end

      local custom_formatters = {}
      local previous_formatters = opts.formatters or {}
      for _, formatter in ipairs(used_formatters) do
        local formatter_opts
        if previous_formatters[formatter] ~= nil then
          formatter_opts = previous_formatters[formatter]
        else
          local ok, module = pcall(require, "conform.formatters." .. formatter)
          if not ok then
            error("Formatter " .. formatter .. " not found")
          end
          formatter_opts = module
        end
        local command = formatter_opts.command
        if command == nil then
          error("Formatter " .. formatter .. " does not have a command")
        end
        local resolved_command = dv.which(command)
        if resolved_command ~= nil then
          custom_formatters[formatter] =
            vim.tbl_extend("force", formatter_opts, {
              command = resolved_command,
            })
        end
      end

      opts.formatters =
        vim.tbl_extend("force", previous_formatters, custom_formatters)
      require("conform").setup(opts)
    end,
  },
}
