return {
  { 'simrat39/rust-tools.nvim', lazy = true },
  Use {
    'saecki/crates.nvim',
    functions = {
      FuncSpec("Disable UI elements (virtual text and diagnostics)", function()
        require('crates').hide()
      end),
      FuncSpec('Enable UI elements (virtual text and diagnostics)', function()
        require('crates').show()
      end),
      FuncSpec("Toggle UI elements (virtual text and diagnostics)", function()
        require('crates').toggle()
      end),
      FuncSpec('Reload data (clears cache)', function()
        require('crates').reload()
      end),
      FuncSpec('Upgrade all crates', function()
        require('crates').upgrade_all_crates()
      end),
    },
    lazy = {
      dependencies = {
        'nvim-lua/plenary.nvim',
        'jose-elias-alvarez/null-ls.nvim',
        'MunifTanjim/nui.nvim',
      },
      event = { 'BufRead Cargo.toml' },
      init = function()
        vim.api.nvim_create_autocmd("BufRead", {
          group = vim.api
              .nvim_create_augroup("CmpSourceCargo", { clear = true }),
          pattern = "Cargo.toml",
          callback = function()
            local cmp = require 'cmp'
            cmp.setup.buffer({ sources = { { name = "crates" } } })
          end,
        })

        local menu = require 'ht.core.menu'

        menu:add_section{
          index = 4,
          filename = { 'Cargo.toml' },
          opts = {
            {
              'Cra&tes',
              children = {
                {
                  'Open Homepage',
                  callback = function()
                    require('crates').open_homepage()
                  end,
                },
                {
                  'Open Documentation',
                  callback = function()
                    require('crates').open_documentation()
                  end,
                },
                {
                  'Open Repository',
                  callback = function()
                    require('crates').open_repository()
                  end,
                  keys = 'r',
                },
                {
                  'Upgrade',
                  callback = function()
                    require('crates').upgrade_crate()
                  end,
                  keys = 'U',
                },
                {
                  'Popups',
                  keys = 'p',
                  children = {
                    {
                      'Details',
                      callback = function()
                        require('crates').show_crate_popup()
                      end,
                      keys = 'd',
                    },
                    {
                      'Versions',
                      callback = function()
                        require('crates').show_versions_popup()
                      end,
                      keys = 'v',
                    },
                    {
                      'Features',
                      callback = function()
                        require('crates').show_features_popup()
                      end,
                      keys = 'f',
                    },
                    {
                      'Dependencies',
                      callback = function()
                        require('crates').show_dependencies_popup()
                      end,
                    },
                  },
                },
              },
            },
          },
        }
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
  },
}
