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
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      completion = {
        enabled_providers = { "lsp", "buffer" },
      },
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

    completion = { accept = { auto_brackets = { enabled = true } } },
    signature = { enabled = true },
  },
}
