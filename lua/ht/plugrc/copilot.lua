return {
  {
    'zbirenbaum/copilot-cmp',
    event = 'InsertEnter',
    dependencies = { 'zbirenbaum/copilot.lua' },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    keys = {
      {
        '<M-a>',
        function()
          require("copilot.suggestion").accept()
        end,
        mode = 'i',
        desc = 'accept-copilot-suggestion',
      },
    },
    config = function()
      require'copilot'.setup { suggestion = { accept = '<M-a>' } }

      local menu = require 'ht.core.menu'

      menu:add_section{
        index = 5,
        opts = {
          {
            'Copilot',
            children = {
              {
                'Status',
                callback = function()
                  vim.api.nvim_command([[Copilot status]])
                end,
              },
              {
                'Auth',
                callback = function()
                  vim.api.nvim_command([[Copilot auth]])
                end,
              },
              {
                'Panel',
                callback = function()
                  vim.api.nvim_command([[Copilot panel]])
                end,
              },
              {
                'Toggle Auto Trigger',
                callback = function()
                  require("copilot.suggestion").toggle_auto_trigger()

                  local cmp = require 'cmp'
                  cmp.event:on("menu_opened", function()
                    vim.b.copilot_suggestion_hidden = true
                  end)

                  cmp.event:on("menu_closed", function()
                    vim.b.copilot_suggestion_hidden = false
                  end)
                end,
              },
            },
          },
        },
      }
    end,
  },
}
