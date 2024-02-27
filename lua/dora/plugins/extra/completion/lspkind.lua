---@type dora.core.plugin.PluginOptions[]
return {
  {
    "onsails/lspkind.nvim",
    after = "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "nvim-cmp",
        opts = function(_, opts)
          local lspkind = require("lspkind")

          opts.formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
              local kind = lspkind.cmp_format {
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = "...",
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
              local strings = vim.split(kind.kind, "%s", { trimempty = true })
              kind.kind = strings[1] .. "  "
              if strings[2] and #strings[2] > 0 then
                kind.menu = "    (" .. strings[2] .. ")"
              else
                kind.menu = ""
              end
              return kind
            end,
          }
        end,
      },
    },
  },
}
