---@type dora.core.plugin.PluginOptions[]
return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufReadPost",
    cmd = { "ConformInfo" },
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      ---@param langs string[]
      ---@param formatter string
      local function bind_formatter(langs, formatter)
        for _, lang in ipairs(langs) do
          if opts.formatters_by_ft[lang] == nil then
            opts.formatters_by_ft[lang] = {}
          end
          table.insert(opts.formatters_by_ft[lang], formatter)
        end
      end

      bind_formatter(
        { "c", "cpp", "cs", "java", "cuda", "proto" },
        "clang-format"
      )
      bind_formatter({ "lua" }, "stylua")
      bind_formatter({ "rust" }, "rustfmt")
      bind_formatter({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
      }, "prettier")
      bind_formatter({ "python" }, "black")
      bind_formatter({ "dart" }, "dart_fmt")
      bind_formatter({ "cmake" }, "gersemi")
      bind_formatter({ "nix" }, "alejandra")
      bind_formatter({ "swift" }, "swift_format")
    end,
    actions = {
      {
        id = "conform.do-format",
        title = "Format File",
        description = "Format the current file using conform.nvim",
        callback = function()
          require("conform").format {
            async = true,
            lsp_fallback = "always",
          }
        end,
        keys = { "<leader>fc", desc = "format-code" },
      },
    },
  },
}
