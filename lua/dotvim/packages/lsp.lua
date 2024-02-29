---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages.lsp",
  deps = {
    "dora.packages.extra.lsp",
  },
  plugins = {
    {
      "aerial.nvim",
      opts = function(_, opts)
        local function post_parse_symbol(_, _item, ctx)
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
        end

        opts.post_parse_symbol = post_parse_symbol
      end,
    },
  },
}
