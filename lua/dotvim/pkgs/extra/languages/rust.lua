---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.package.PackageOption
return {
  name = "extra.languages.rust",
  deps = {
    "coding",
    "lsp",
    "editor",
    "treesitter",
  },
  setup = function()
    local on_rust_file = function(event)
      -- add key bindings
      local bufnr = event.buf
      local add_map = function(lhs, rhs, desc)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>h" .. lhs, "", {
          callback = rhs,
          noremap = true,
          nowait = true,
          silent = true,
          desc = "rust-" .. desc,
        })
      end

      add_map("e", function()
        vim.api.nvim_command("RustLsp expandMacro")
      end, "expand-macro")
      add_map("c", function()
        vim.api.nvim_command("RustLsp openCargo")
      end, "open-cargo")
      add_map("p", function()
        vim.api.nvim_command("RustLsp parentModule")
      end, "parent-module")
    end

    local on_cargo_toml = function(event)
      -- add key bindings
      local bufnr = event.buf
      local add_map = function(lhs, rhs, desc)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>h" .. lhs, "", {
          callback = rhs,
          noremap = true,
          nowait = true,
          silent = true,
          desc = "cargo-toml-" .. desc,
        })
      end

      add_map("h", function()
        require("crates").open_homepage()
      end, "open-homepage")

      add_map("d", function()
        require("crates").open_documentation()
      end, "open-documentation")

      add_map("r", function()
        require("crates").open_repository()
      end, "open-repository")

      add_map("u", function()
        require("crates").upgrade_crate()
      end, "upgrade-crate")

      add_map("c", function()
        require("crates").show_crate_popup()
      end, "open-crate-popup")

      add_map("v", function()
        require("crates").show_versions_popup()
      end, "open-versions-popup")

      add_map("f", function()
        require("crates").show_features_popup()
      end, "open-features-popup")
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = on_rust_file,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "Cargo.toml",
      callback = function(event)
        local bufnr = event.buf

        if
          Utils.vim.buf_get_var(bufnr, "_dotvim_extra_rust_cargo_toml") == 1
        then
          return
        end
        vim.api.nvim_buf_set_var(bufnr, "_dotvim_extra_rust_cargo_toml", 1)

        on_cargo_toml(event)
      end,
    })
  end,
  plugins = {
    {
      "nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "rust" })
        end
      end,
    },
    {
      "saecki/crates.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
      event = {
        {
          event = "BufEnter",
          pattern = "Cargo.toml",
        },
      },
      init = function()
        vim.api.nvim_create_autocmd("BufRead", {
          group = vim.api.nvim_create_augroup(
            "CmpSourceCargo",
            { clear = true }
          ),
          pattern = "Cargo.toml",
          callback = function()
            local cmp = require("cmp")
            cmp.setup.buffer { sources = { { name = "crates" } } }

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
        src = {
          cmp = {
            enabled = true,
          },
        },
      },
      config = function(_, opts)
        require("crates").setup(opts)
        require("crates").update()
      end,
      actions = function()
        ---@type dotvim.core.action
        local action = require("dotvim.core.action")

        return action.make_options {
          from = "crates.nvim",
          category = "Crates",
          condition = function(buf)
            --- check if buf.full_file_name endwidths "Cargo.toml"
            return buf.full_file_name:match("Cargo.toml$")
          end,
          actions = {
            {
              id = "crates-nvim.open-homepage",
              title = "Open homepage under cursor",
              callback = function()
                require("crates").open_homepage()
              end,
            },
            {
              id = "crates-nvim.open-documentation",
              title = "Open documentation under cursor",
              callback = function()
                require("crates").open_documentation()
              end,
            },
            {
              id = "crates-nvim.open-repository",
              title = "Open repository under cursor",
              callback = function()
                require("crates").open_repository()
              end,
            },
            {
              id = "crates-nvim.upgrade-crate",
              title = "Upgrade crate under cursor",
              callback = function()
                require("crates").upgrade_crate()
              end,
            },
            {
              id = "crates-nvim.open-crate-popup",
              title = "Open crate popup",
              callback = function()
                require("crates").show_crate_popup()
              end,
            },
            {
              id = "crates-nvim.open-versions-popup",
              title = "Open versions popup",
              callback = function()
                require("crates").show_versions_popup()
              end,
            },
            {
              id = "crates-nvim.open-features-popup",
              title = "Open features popup",
              callback = function()
                require("crates").show_features_popup()
              end,
            },
            {
              id = "crates-nvim.open-dependencies-popup",
              title = "Open dependencies popup",
              callback = function()
                require("crates").show_dependencies_popup()
              end,
            },
          },
        }
      end,
    },
    {
      "conform.nvim",
      opts = {
        formatters_by_ft = {
          rust = { "rustfmt" },
        },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      version = "*",
      dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
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
                  },
                  watcherExclude = {
                    ".direnv",
                    ".devenv",
                  },
                },
                lru = { capacity = 1024 * 2 },
              },
            },
          },
        }
      end,
      actions = function()
        ---@type dotvim.core.action
        local action = require("dotvim.core.action")

        return action.make_options {
          from = "rustaceanvim",
          category = "Rustaceanvim",
          condition = function(buf)
            for _, server in ipairs(buf.lsp_servers) do
              if server.name == "rust-analyzer" then
                return true
              end
            end
            return false
          end,
          actions = {
            {
              id = "rustaceanvim.expand-macro",
              title = "Expand macro",
              callback = function()
                vim.api.nvim_command("RustLsp expandMacro")
              end,
            },
            {
              id = "rustaceanvim.rebuild-proc-macro",
              title = "Rebuild proc macro",
              callback = function()
                vim.api.nvim_command("RustLsp rebuildProcMacros")
              end,
            },
            {
              id = "rustaceanvim.move-item-up",
              title = "Move item up",
              callback = function()
                vim.api.nvim_command("RustLsp moveItem up")
              end,
            },
            {
              id = "rustaceanvim.move-item-down",
              title = "Move item down",
              callback = function()
                vim.api.nvim_command("RustLsp moveItem down")
              end,
            },
            {
              id = "rustaceanvim.hover-actions",
              title = "Hover actions",
              callback = function()
                vim.api.nvim_command("RustLsp hover actions")
              end,
            },
            {
              id = "rustaceanvim.hover-range",
              title = "Hover range",
              callback = function()
                vim.api.nvim_command("RustLsp hover range")
              end,
            },
            {
              id = "rustaceanvim.explain-errors",
              title = "Explain errors",
              callback = function()
                vim.api.nvim_command("RustLsp explainError")
              end,
            },
            {
              id = "rustaceanvim.render-diagnostic",
              title = "Render diagnostic",
              callback = function()
                vim.api.nvim_command("RustLsp renderDiagnostic")
              end,
            },
            {
              id = "rustaceanvim.open-cargo-toml",
              title = "Open cargo.toml of this file",
              callback = function()
                vim.api.nvim_command("RustLsp openCargo")
              end,
            },
            {
              id = "rustaceanvim.open-parent-module",
              title = "Open parent module of this file",
              callback = function()
                vim.api.nvim_command("RustLsp parentModule")
              end,
            },
            {
              id = "rustaceanvim.join-lines",
              title = "Join lines",
              callback = function()
                vim.api.nvim_command("RustLsp joinLines")
              end,
            },
            {
              id = "rustaceanvim.structural-search-replace",
              title = "Structural search replace",
              callback = function()
                vim.api.nvim_command("RustLsp ssr")
              end,
            },
            {
              id = "rustaceanvim.view-syntax-tree",
              title = "View syntax tree",
              callback = function()
                vim.api.nvim_command("RustLsp syntaxTree")
              end,
            },
          },
        }
      end,
    },
    {
      "neotest",
      opts = function(_, opts)
        table.insert(opts.adapters, require("rustaceanvim.neotest"))
      end,
    },
  },
}
