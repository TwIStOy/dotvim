local M = {}

local highlight_created = false

---@class DisplayMenuOptions
---@field init_winnr any
---@field row number
---@field col number
local DisplayMenuOptions = {}

---Calculate the width of the longest text in the given items.
---@param items ContextMenuItem[]
---@return integer
local function max_text_width(items)
  local max_width = 0
  local additional = 0
  for _, item in ipairs(items) do
    max_width = math.max(max_width, #item.text)
    if item.children ~= nil and #item.children > 0 then
      additional = 2
    end
  end
  return max_width + additional
end

---@return DisplayMenuOptions
local function initialize_options()
  local first_line = vim.fn.line('w0')
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local winnr = vim.api.nvim_get_current_win()
  r = r - first_line + 2
  c = c + 8
  return { init_winnr = winnr, row = r, col = c }
end

---@param item NuiTreeNode
---@param menu NuiMenu
---@return number|nil
local find_item_in_menu = function(item, menu)
  local pos = nil
  for i, val in ipairs(menu.tree.nodes.root_ids) do
    if val == item:get_id() then
      pos = i
    end
  end
  return pos
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
    winhighlight = "NormalSB:Normal,FloatBorder:FloatBorder,CursorLine:MenuSel",
  },
}

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

---@param item NuiTreeNode
---@param menu NuiMenu
local function on_expand(item, menu)
  ---@type ContextMenuItem
  local menu_item = item.menu_item
  ---@type ContextMenuContext
  local menu_context = menu.menu_props.menu_context

  local new_menu_context = { parent = menu_context }

  local pos = find_item_in_menu(item, menu)
  local display_options = {
    init_winnr = menu_context.display_options.init_winnr,
    row = menu_context.display_options.row + pos - 1,
    col = menu_context.display_options.col + menu.win_config.width + 4,
  }
  local new_menu = M.create_menu(menu_item.children, display_options, menu)
  new_menu:mount()
end

---comment
---@param items ContextMenuItem[]
---@param opts DisplayMenuOptions|nil
---@param parent NuiMenu|nil
function M.create_menu(items, opts, parent)
  if highlight_created == false then
    highlight_created = true
    local function background(hi)
      return string.format("#%06x",
                           vim.api.nvim_get_hl_by_name(hi, 1).background)
    end

    local function foreground(hi)
      return string.format("#%06x",
                           vim.api.nvim_get_hl_by_name(hi, 1).foreground)
    end
    vim.cmd("highlight MenuSel gui=bold guibg=" .. background('IncSearch') ..
                " guifg=" .. foreground('IncSearch'))
  end

  if opts == nil then
    opts = initialize_options()
  end
  local Menu = require 'nui.menu'

  local popup_options = vim.tbl_extend("force", default_popup_options, {
    position = { row = opts.row, col = opts.col },
    relative = { winid = opts.init_winnr, type = 'win' },
  })
  local lines = {}
  local sub_text_width = max_text_width(items)
  for _, item in ipairs(items) do
    table.insert(lines, item:as_nui_menu_item(sub_text_width))
  end
  local menu_options = vim.tbl_extend('force', default_menu_options,
                                      { lines = lines })

  ---@type NuiMenu
  local menu = Menu(popup_options, menu_options)
  menu.menu_props.menu_context = { display_options = opts, parent = parent }

  -- define keymaps
  menu:map('n', 'h', function()
    menu.menu_props.on_close()
  end, { noremap = true, nowait = true })
  menu:map('n', 'l', function()
    local item = menu.tree:get_node()
    ---@type ContextMenuItem
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

return M
