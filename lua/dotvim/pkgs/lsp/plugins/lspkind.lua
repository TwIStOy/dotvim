local MAX_MENU_WIDTH = 20
local MIN_ABBR_WIDTH = 25

---@type dotvim.core.plugin.PluginOption
return {
  "onsails/lspkind.nvim",
  lazy = true,
  opts = {
    symbol_map = {
      TypeParameter = "",
    },
  },
  config = function(_, opts)
    require("lspkind").init(opts)
  end,
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
                if e.source.name == "latex_symbols" then
                  item.kind = "Math"
                end
                return item
              end,
            }(entry, vim_item)
            local strings = vim.split(ret.kind, "%s", { trimempty = true })
            ret.kind = strings[1] .. "  "

            if #ret.abbr < MIN_ABBR_WIDTH then
              ret.abbr = ret.abbr .. string.rep(" ", MIN_ABBR_WIDTH - #ret.abbr)
            end

            local menu_text = vim.F.if_nil(
              require("dotvim.extra.lsp").get_lsp_item_import_location(
                entry.completion_item,
                entry.source
              ),
              ""
            )
            if #menu_text > MAX_MENU_WIDTH then
              menu_text = menu_text:sub(1, MAX_MENU_WIDTH - 3) .. "..."
            end
            ret.menu = menu_text

            return ret
          end,
        }
      end,
    },
  },
}
