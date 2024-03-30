---@type dotvim.core.plugin.PluginOption
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter",
    "nvim-web-devicons",
    "telescope.nvim",
  },
  cmd = {
    "AerialToggle",
    "AerialOpen",
    "AerialOpenAll",
    "AerialClose",
    "AerialCloseAll",
    "AerialNext",
    "AerialPrev",
    "AerialGo",
    "AerialInfo",
    "AerialNavToggle",
    "AerialNavOpen",
    "AerialNavClose",
  },
  opts = {
    backends = { "lsp", "markdown", "man" },
    layout = {
      default_direction = "right",
      placement = "edge",
      preserve_equality = true,
    },
    attach_mode = "global",
    filter_kind = false,
    show_guides = true,
    post_parse_symbol = function(_, _item, ctx)
      local function merge_nested_namespaces(item)
        if
          item.kind == "Namespace"
          and #item.children == 1
          and item.children[1].kind == "Namespace"
          and item.lnum == item.children[1].lnum
          and item.end_lnum == item.children[1].end_lnum
        then
          item.name = item.name .. "::" .. item.children[1].name
          item.children = item.children[1].children
          for _, child in ipairs(item.children) do
            child.parent = item
            child.level = item.level + 1
          end
          merge_nested_namespaces(item)
        end
      end
      if ctx.backend_name == "lsp" and ctx.lang == "clangd" then
        merge_nested_namespaces(_item)
      end
      return true
    end,
  },
  config = function(_, opts)
    require("aerial").setup(opts)
    require("telescope").load_extension("aerial")
  end,
}
