local function update_config()
  ---@type dora.config
  local config = require("dora.config")
  config.lsp.config.server_opts.clangd =
    vim.tbl_deep_extend("keep", config.lsp.config.server_opts.clangd or {}, {
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
      cmd = {
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
        "-j=20",
      },
      root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
          "Makefile",
          "configure.ac",
          "configure.in",
          "config.h.in",
          "meson.build",
          "meson_options.txt",
          "build.ninja",
          "BLADE_ROOT"
        )(fname) or require("lspconfig.util").root_pattern(
          "compile_commands.json",
          "compile_flags.txt"
        )(fname) or require("lspconfig.util").find_git_ancestor(fname)
      end,
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    })
  if config.lsp.config.setups.clangd == nil then
    config.lsp.config.setups.clangd = function()
      require("clangd_extensions").setup {
        autoSetHints = false,
        hover_with_actions = true,
        inlay_hints = {
          inline = false,
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
          show_parameter_hints = false,
          show_variable_name = true,
          other_hints_prefix = "",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        ast = {
          role_icons = {
            type = "🄣",
            declaration = "🄓",
            expression = "🄔",
            statement = ";",
            specifier = "🄢",
            ["template argument"] = "🆃",
          },
          kind_icons = {
            Compound = "🄲",
            Recovery = "🅁",
            TranslationUnit = "🅄",
            PackExpansion = "🄿",
            TemplateTypeParm = "🅃",
            TemplateTemplateParm = "🅃",
            TemplateParamObject = "🅃",
          },
        },
        memory_usage = { border = "rounded" },
        symbol_info = { border = "rounded" },
      }
    end
  end
end

---@type dora.core.plugin.PluginOptions[]
return {
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    after = {
      "nvim-cmp",
      "nvim-lspconfig",
    },
    config = function() end,
    dependencies = {
      {
        "nvim-cmp",
        opts = function(_, opts)
          table.insert(
            opts.sorting.comparators,
            1,
            require("clangd_extensions.cmp_scores")
          )
        end,
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = update_config,
  },
}
