---@type dora.core.plugin.PluginOption
return {
  "onsails/lspkind.nvim",
  lazy = true,
  dependencies = {
    {
      "nvim-cmp",
      opts = function(_, opts)
        local lspkind = require("lspkind")

        opts.formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local ret = lspkind.cmp_format {
              mode = "symbol_text",
              maxwidth = 50,
              ellipsis_char = "...",
              show_labelDetails = true,
              before = function(e, item)
                item.menu = ({
                  buffer = "[Buf]",
                  nvim_lsp = "[LSP]",
                  ultisnips = "[Snip]",
                  luasnip = "[Snip]",
                  nvim_lua = "[Lua]",
                  orgmode = "[Org]",
                  path = "[Path]",
                  dap = "[DAP]",
                  emoji = "[Emoji]",
                  calc = "[CALC]",
                  latex_symbols = "[LaTeX]",
                  cmdline_history = "[History]",
                  cmdline = "[Command]",
                  copilot = "[Copilot]",
                })[e.source.name] or ("[" .. e.source.name .. "]")
                if e.source.name == "latex_symbols" then
                  item.kind = "Math"
                end
                return item
              end,
            }(entry, vim_item)
            local strings = vim.split(ret.kind, "%s", { trimempty = true })
            ret.kind = strings[1] .. "  "
            if strings[2] and #strings[2] > 0 then
              ret.menu = "    (" .. strings[2] .. ")"
            else
              ret.menu = ""
            end
            return ret
          end,
        }
      end,
    },
  },
}
