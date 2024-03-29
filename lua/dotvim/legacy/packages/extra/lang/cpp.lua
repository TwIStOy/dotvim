---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.lang.cpp",
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
          vim.list_extend(opts.ensure_installed, { "c", "cpp" })
        end
      end,
    },
    {
      "mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.extra.ensure_installed, {
          "clangd",
          "cpplint",
          "clang-format",
        })
      end,
    },
    {
      "nvim-lspconfig",
      opts = {
        servers = {
          opts = {
            clangd = {
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
                )(fname) or require("lspconfig.util").find_git_ancestor(
                  fname
                )
              end,
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
            },
          },
          setup = {
            clangd = function(_, server_opts)
              ---@type dora.lib
              local lib = require("dora.lib")

              lib.vim.on_lsp_attach(function(client, bufnr)
                if client and client.name == "clangd" then
                  vim.keymap.set("n", "<leader>fa", function()
                    vim.api.nvim_command("ClangdSwitchSourceHeader")
                  end, {
                    desc = "clangd-switch-header",
                    buffer = bufnr,
                  })
                end
              end)

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

              -- call default setup function
              require("lspconfig").clangd.setup(server_opts)

              return true
            end,
          },
        },
      },
    },
    {
      "p00f/clangd_extensions.nvim",
      lazy = true,
      after = {
        "nvim-cmp",
        "nvim-lspconfig",
      },
      config = function() end,
    },
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
    {
      "TwIStOy/cpp-toolkit.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
      gui = "all",
      cmd = { "CppGenDef", "CppDebugPrint", "CppToolkit" },
      ft = { "cpp", "c" },
      opts = {
        impl_return_type_style = "trailing",
      },
      config = function(_, opts)
        require("cpp-toolkit").setup(opts)
        require("telescope").load_extension("cpptoolkit")
      end,
      actions = function()
        ---@type dora.core.action
        local action = require("dora.core.action")

        return action.make_options {
          from = "cpp-toolkit.nvim",
          category = "CppToolkit",
          actions = {
            {
              id = "cpptoolkit.insert-header",
              title = "Insert header",
              callback = "Telescope cpptoolkit insert_header",
            },
            {
              id = "cpptoolkit.gen-def",
              title = "Generate function implementation",
              callback = "CppGenDef",
            },
            {
              id = "cpptoolkit.move-value",
              title = "Move value",
              callback = "CppToolkit shortcut move_value",
            },
            {
              id = "cpptoolkit.forward-value",
              title = "Forward value",
              callback = "CppToolkit shortcut forward_value",
            },
          },
        }
      end,
    },
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufNewFile" },
      opts = function(_, opts)
        opts.linters_by_ft.cpp = { "cpplint" }
      end,
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          cpp = { "clang_format" },
        },
      },
    },
    {
      "dial.nvim",
      opts = function(_, opts)
        local function define_custom(...)
          local augend = require("dial.augend")
          return augend.constant.new {
            elements = { ... },
            word = true,
            cyclic = true,
          }
        end

        if opts.ft.cpp == nil then
          opts.ft.cpp = {}
        end

        vim.list_extend(opts.ft.cpp, {
          define_custom("Debug", "Info", "Warn", "Error", "Fatal"),
          define_custom("first", "second"),
          define_custom("true_type", "false_type"),
          define_custom("uint8_t", "uint16_t", "uint32_t", "uint64_t"),
          define_custom("int8_t", "int16_t", "int32_t", "int64_t"),
          define_custom("htonl", "ntohl"),
          define_custom("htons", "ntohs"),
          define_custom("ASSERT_EQ", "ASSERT_NE"),
          define_custom("EXPECT_EQ", "EXPECT_NE"),
          define_custom("==", "!="),
          define_custom("static_cast", "dynamic_cast", "reinterpret_cast"),
          define_custom("private", "public", "protected"),
        })
      end,
    },
  },
}
