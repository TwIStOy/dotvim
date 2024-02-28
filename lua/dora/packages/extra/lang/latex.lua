---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.latex",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
    "dora.packages.treesitter",
  },
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "latex" })
        end
      end,
    },
    {
      "kdheepak/cmp-latex-symbols",
      ft = "latex",
    },
    {
      "nvim-cmp",
      opts = function(_, opts)
        local function in_latex_scope()
          local context = require("cmp.config.context")
          local ft = vim.api.nvim_get_option_value("filetype", {
            buf = 0,
          })
          if ft ~= "markdown" and ft ~= "latex" then
            return false
          end
          return context.in_treesitter_capture("text.math")
        end

        table.insert(opts.sources, {
          name = "latex_symbols",
          filetype = { "tex", "latex", "markdown" },
          group_index = 1,
          option = {
            cache = true,
            strategy = 2, -- latex only
          },
          entry_filter = function(_, ctx)
            if ctx.in_latex_scope == nil then
              ctx.in_latex_scope = in_latex_scope()
            end
            return ctx.in_latex_scope
          end,
        })
      end,
    },
    {
      "jbyuki/nabla.nvim",
      ft = { "latex", "markdown" },
      keys = {
        {
          "<leader>pf",
          function()
            require("nabla").popup {
              border = "solid",
            }
          end,
          ft = { "latex", "markdown" },
        },
      },
    },
  },
}
