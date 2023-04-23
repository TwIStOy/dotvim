local M = {}

function M.test_context_menu()
  local context_menu_item = RR 'ht.core.ui.context_menu.item'
  local context_menu_actions = RR 'ht.core.ui.context_menu.actions'

  local test_config = {
    {
      'item0',
      action = function()
        print('item0')
      end,
    },
    {
      'it&em1',
      action = function()
        print('item1')
      end,
      children = {
        {
          'sub0',
          action = function()
            print('sub0')
          end,
        },
        {
          'sub1',
          action = function()
            print('sub1')
          end,
        },
      },
    },
    {
      'ite&m2',
      action = function()
        print('item2')
      end,
    },
  }
  local items = {}
  for _, v in ipairs(test_config) do
    table.insert(items, context_menu_item.new(v))
  end
  ---@type NuiMenu
  local menu = context_menu_actions.create_menu(items)
  menu:mount()
end

return M
