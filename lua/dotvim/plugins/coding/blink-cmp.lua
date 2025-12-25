---@type LazyPluginSpec
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "VeryLazy",
  enabled = not vim.g.vscode,
  opts_extend = { "sources.default" },
  opts = {
    fuzzy = {
      prebuilt_binaries = {
        download = true,
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
      keyword = { range = "full" },
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
                return require("colorful-menu").blink_components_highlight(ctx)
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
}
