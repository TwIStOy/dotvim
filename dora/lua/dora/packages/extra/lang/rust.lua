---@type dora.core.package.PackageOption
return {
  name = "extra.lang.rust",
  deps = {
    "coding",
    "lsp",
    "treesitter",
  },
  plugins = {
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
        require("crates").udpate()
      end,
      actions = function()
        ---@type dora.core.action
        local action = require("dora.core.action")

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
          rust = { "rust_format" },
        },
      },
    },
  },
}
