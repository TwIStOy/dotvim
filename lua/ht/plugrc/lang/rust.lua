return {
  { 'simrat39/rust-tools.nvim', lazy = true },
  {
    'saecki/crates.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'MunifTanjim/nui.nvim',
    },
    event = { 'BufRead Cargo.toml' },
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          local cmp = require 'cmp'
          cmp.setup.buffer({ sources = { { name = "crates" } } })
        end,
      })

      local menu = require 'ht.core.menu'
      local Menu = require 'nui.menu'

      menu:append_file_section('Cargo.toml', {
        Menu.item('Crates', {
          items = {
            Menu.item('Open Homepage', {
              action = function()
                require('crates').open_homepage()
              end,
            }),
            Menu.item('Open Documentation', {
              action = function()
                require('crates').open_documentation()
              end,
            }),
            Menu.item('Open Repository', {
              action = function()
                require('crates').open_repository()
              end,
            }),
            Menu.item('Popups', {
              items = {
                Menu.item('Details', {
                  action = function()
                    require('crates').show_crate_popup()
                  end,
                }),
                Menu.item('Versions', {
                  action = function()
                    require('crates').show_versions_popup()
                  end,
                }),
                Menu.item('Features', {
                  action = function()
                    require('crates').show_features_popup()
                  end,
                }),
                Menu.item('Dependencies', {
                  action = function()
                    require('crates').show_dependencies_popup()
                  end,
                }),
              },
            }),
          },
        }),
      }, 4)
    end,
    config = function()
      require('crates').setup {
        autoload = true,
        popup = { autofocus = true, border = 'rounded' },
        null_ls = { enabled = true, name = "crates.nvim" },
      }

      -- BufRead event is missing, because of lazy-loading
      require('crates').update()
    end,
  },
}

