---@type dora.core.plugin.PluginOption[]
return {
  {
    "kdheepak/cmp-latex-symbols",
    ft = "latex",
    after = "hrsh7th/nvim-cmp",
    dependencies = {
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
    },
  },
}
