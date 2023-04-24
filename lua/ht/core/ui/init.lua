local M = {}

function M.test_context_menu()
  local context_menu = RR 'ht.core.ui.components.context_menu'

  local test_config = {
    {
      'item0',
      callback = function()
        print('item0')
      end,
    },
    {
      'it&em1',
      callback = function()
        print('item1')
      end,
      children = {
        {
          'sub0',
          callback = function()
            print('sub0')
          end,
        },
        {
          'sub1',
          callback = function()
            print('sub1')
          end,
        },
      },
    },
    { '---' },
    {
      'ite&m2',
      callback = function()
        print('item2')
      end,
    },
  }
  ---@type ContextMenu
  local menu = context_menu(test_config)
  menu:as_nui_menu():mount()
end

return M
