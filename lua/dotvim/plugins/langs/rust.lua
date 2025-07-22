---@type LazyPluginSpec[]
return {
  {
    "saecki/crates.nvim",
    event = {
      {
        event = "BufEnter",
        pattern = "Cargo.toml",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          vim.keymap.set("n", "K", function()
            if require("crates").popup_available() then
              require("crates").show_popup()
            end
          end, {
            buffer = true,
          })
        end,
      })
    end,
    opts = {
      autoload = true,
      popup = { autofocus = true, border = "rounded" },
    },
    config = function(_, opts)
      require("crates").setup(opts)
      require("crates").update()
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "*",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = {
            workspace = {
              inlayHint = {
                refreshSupport = false,
              },
            },
          },
          default_settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  enforce = true,
                  group = "crate",
                },
                prefix = "crate",
              },
              semanticHighlighting = {
                operator = { specialization = { enable = true } },
                punctuation = { enable = true },
              },
              inlayHints = {
                typeHints = {
                  enable = false,
                },
                parameterHints = {
                  enable = false,
                },
                chainingHints = {
                  enable = false,
                },
                closingBraceHints = {
                  enable = false,
                },
                renderColons = false,
              },
              completion = {
                postfix = {
                  enable = false,
                },
                privateEditable = {
                  enable = false,
                },
              },
              check = {
                command = "clippy",
              },
              files = {
                watcher = "server",
                excludeDirs = {
                  ".direnv",
                  ".devenv",
                  "target",
                },
                watcherExclude = {
                  ".direnv",
                  ".devenv",
                  "target",
                },
              },
              lru = { capacity = 1024 * 2 },
            },
          },
        },
      }
    end,
  },
}
