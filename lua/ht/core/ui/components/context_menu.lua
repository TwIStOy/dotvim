---@class ContextMenu
---@field items MenuItem[]
local ContextMenu = {}

---@class MenuDisplayOptions
---@field init_winnr any
---@field row number
---@field col number
local DisplayMenuOptions = {}

local function new_context_menu(opts)
  local menu_item = require 'ht.core.ui.components.menu_item'
  local items = {}
  for _, opt in ipairs(opts) do
    local item = menu_item(opt)
    if item ~= nil then
      table.insert(items, item)
    end
  end
  local this = { items = items, parent = nil, rendered = nil }
  setmetatable(this, { __index = ContextMenu })
  return this
end

local default_popup_options = {
  relative = { type = "win" },
  focusable = false,
  buf_options = { modifiable = false, readonly = true, filetype = 'nuipopup' },
  border = {
    style = "rounded",
    highlight = "FloatBorder",
    padding = { top = 0, bottom = 0, left = 1, right = 1 },
  },
  win_options = {
    winblend = 0,
    winhighlight = "NormalSB:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine",
  },
}

---@param item NuiTreeNode
---@param menu NuiMenu
---@return number|nil
local function find_item_in_menu(item, menu)
  local pos = nil
  for i, val in ipairs(menu.tree.nodes.root_ids) do
    if val == item:get_id() then
      pos = i
    end
  end
  return pos
end

---@param item NuiTreeNode
---@param menu NuiMenu
local function on_expand(item, menu)
  ---@type MenuItem
  local menu_item = item.menu_item
  local menu_context = menu.menu_props.menu_context

  local new_menu_context = { parent = menu_context }

  local pos = find_item_in_menu(item, menu)
  local display_options = {
    init_winnr = menu_context.display_options.init_winnr,
    row = menu_context.display_options.row + pos - 1,
    col = menu_context.display_options.col + menu.win_config.width + 4,
  }
  local context_menu = { items = {} }
  for _, child in ipairs(menu_item.children) do
    table.insert(context_menu.items, child)
  end
  setmetatable(context_menu, { __index = ContextMenu })

  local new_menu = context_menu:as_nui_menu(display_options, menu)
  new_menu:mount()
end

local default_menu_options = {
  min_width = 20,
  max_width = 120,
  keymap = {
    focus_next = { "j", "<DOWN>", "<C-n>", "<TAB>" },
    focus_prev = { "k", "<UP>", "<C-p>", "<S-TAB>" },
    close = { "<ESC>", "<C-c>" },
    submit = { "<CR>" },
  },
  on_close = function()
  end,
  on_change = function(item, menu)
    ---@type ContextMenuContext
    local menu_context = menu.menu_props.menu_context
    if menu_context.keymaps == nil then
      for linenr = 1, #menu.tree.nodes.root_ids do
        local node, target_linenr = menu.tree:get_node(linenr)
        if not menu._.should_skip_item(node) then
          ---@type ContextMenuItem
          local menu_item = node.menu_item

          for key, v in pairs(menu_item.keys) do
            if v then
              menu:map('n', key, function()
                vim.api.nvim_win_set_cursor(menu.winid, { target_linenr, 0 })
                menu._.on_change(node)
              end, { noremap = true, nowait = true })
            end
          end
        end
      end
      menu_context.keymaps = true
    end

    ---@type ContextMenuItem
    local menu_item = item.menu_item
    item.menu_item.in_menu = menu
    if menu_item.desc ~= nil then
      print(menu_item.desc)
    else
      print('\n\n')
    end
  end,
  on_submit = function(item)
    ---@type ContextMenuItem
    local menu_item = item.menu_item
    local menu = menu_item.in_menu
    ---@type ContextMenuContext
    local menu_context = menu.menu_props.menu_context

    -- close all previous menus
    if menu_context.parent ~= nil then
      menu_context.parent:unmount()
    end

    if menu_context.parent == nil then
      -- the last menu, skip
      vim.api.nvim_set_current_win(menu_context.display_options.init_winnr)
    end

    if menu_item.callback ~= nil then
      menu_item.callback()
    end
  end,
}

---Calculate the width of the longest text in the given items.
---@param items MenuItem[]
---@return number
local function max_text_width(items)
  local max_width = 0
  local additional = 0
  for _, item in ipairs(items) do
    max_width = math.max(max_width, item.text:length())
    if item.children ~= nil and #item.children > 0 then
      additional = 2
    end
  end
  return max_width + additional
end

---@return MenuDisplayOptions
local function initialize_options()
  local first_line = vim.fn.line('w0')
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local winnr = vim.api.nvim_get_current_win()
  r = r - first_line + 2
  c = c + 8
  return { init_winnr = winnr, row = r, col = c }
end

---@param opts MenuDisplayOptions|nil
---@param parent NuiMenu|nil
function ContextMenu:as_nui_menu(opts, parent)
  if opts == nil then
    opts = initialize_options()
  end
  local nui_menu = require 'nui.menu'

  local popup_options = vim.tbl_extend("force", default_popup_options, {
    position = { row = opts.row, col = opts.col },
    relative = { winid = opts.init_winnr, type = 'win' },
  })
  local lines = {}
  local sub_text_width = max_text_width(self.items)
  for _, item in ipairs(self.items) do
    table.insert(lines, item:as_nui_node(sub_text_width))
  end
  local menu_options = vim.tbl_extend('force', default_menu_options,
                                      { lines = lines })

  ---@type NuiMenu
  local menu = nui_menu(popup_options, menu_options)
  menu.menu_props.menu_context = { display_options = opts, parent = parent }

  -- define keymaps
  menu:map('n', 'h', function()
    menu.menu_props.on_close()
  end, { noremap = true, nowait = true })
  menu:map('n', 'l', function()
    local item = menu.tree:get_node()
    ---@type MenuItem
    local menu_item = item.menu_item
    if menu_item.children ~= nil and #menu_item.children > 0 then
      on_expand(item, menu)
    end
  end, { noremap = true, nowait = true })

  menu:on('WinClosed', function()
    if parent == nil then
      -- the last menu, skip
      vim.api.nvim_set_current_win(opts.init_winnr)
    end
  end)

  return menu
end

return new_context_menu
