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
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        -- add dora.nvim into
        if opts.servers.opts.lua_ls ~= nil then
          table.insert(
            opts.servers.opts.lua_ls.settings.Lua.workspace.library,
            vim.fn.stdpath("data") .. "/lazy/dora.nvim/lua"
          )
        end
        if opts.servers.opts.clangd ~= nil then
          opts.servers.opts.clangd.cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
            "--background-index-priority=normal",
            "--ranking-model=decision_forest",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--limit-references=100",
            "--limit-results=100",
            "--include-cleaner-stdlib",
            "--all-scopes-completion",
            "-j=20",
          }
        end
      end,
    },
    {
      "catppuccin",
      opts = function(_, opts)
        local clear_diagnostic_background = function(c)
          return {
            DiagnosticVirtualTextError = {
              bg = c.none,
            },
            DiagnosticVirtualTextWarn = {
              bg = c.none,
            },
            DiagnosticVirtualTextInfo = {
              bg = c.none,
            },
            DiagnosticVirtualTextHint = {
              bg = c.none,
            },
          }
        end
        if opts.custom_highlights ~= nil then
          local old_custom_highlights = opts.custom_highlights
          if type(old_custom_highlights) == "function" then
            opts.custom_highlights = function(c)
              local ret = old_custom_highlights(c)
              return vim.tbl_deep_extend(
                "force",
                ret,
                clear_diagnostic_background(c)
              )
            end
          else
            opts.custom_highlights = function(c)
              local ret = old_custom_highlights
              return vim.tbl_deep_extend(
                "force",
                ret,
                clear_diagnostic_background(c)
              )
            end
          end
        else
          opts.custom_highlights = clear_diagnostic_background
        end
      end,
    },
  },
}
