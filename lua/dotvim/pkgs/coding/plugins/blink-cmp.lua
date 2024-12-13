---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "saghen/blink.cmp",
  lazy = false,
  build = (function()
    if Utils.nix.is_nix_managed() then
      return "nix run .#build-plugin"
    else
      return "cargo build --release"
    end
  end)(),
  enabled = function()
    return vim.g.dotvim_completion_engine == "blink-cmp"
  end,
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
  opts_extend = { "sources.default" },
  opts = {
    keymap = {
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
    sources = {
      default = { "lsp", "buffer" },
      providers = {},
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
        selection = "auto_insert",
      },
      menu = {
        scrolloff = 2,
        scrollbar = true,
        -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        border = "none",
        draw = {
          gap = 2,
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
          },
          components = {
            label = {
              width = { max = 60 },
            },
            label_description = {
              text = function(ctx)
                if ctx.source_name == "LSP" then
                  local menu_text = vim.F.if_nil(
                    require("dotvim.extra.lsp").get_lsp_item_import_location(
                      ctx.item,
                      ctx.source
                    ),
                    ""
                  )
                  if #menu_text > 0 then
                    return menu_text
                  end
                end
                return ctx.label_description
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
