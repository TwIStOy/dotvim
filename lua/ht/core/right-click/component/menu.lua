local UtilsTable = require("ht.utils.table")

---@class ht.right_click.MenuDisplayOptions
---@field init_winnr any
---@field row number
---@field col number

---@class ht.right_click.Menu
---@field items ht.right_click.MenuItem[]
---@field parent ht.right_click.Menu?
---@field rendered any?
local ContextMenu = {}

local MenuItem = require("ht.core.right-click.component.menu-item")

---@param opts any[]
---@return ht.right_click.Menu
function ContextMenu.new(opts)
  local items = {}
  for _, opt in ipairs(opts) do
    local item = MenuItem.new(opt)
    if item ~= nil then
      items[#items + 1] = item
    end
  end
  local this = { items = items, parent = nil, rendered = nil }
  setmetatable(this, { __index = ContextMenu })
  return this
end

local default_popup_options = {
  relative = { type = "win" },
  focusable = false,
  buf_options = {
    modifiable = false,
    readonly = true,
    filetype = "rightclickpopup",
  },
  zindex = 210,
  border = {
    style = "single",
    highlight = "FloatBorder",
    padding = { top = 0, bottom = 0, left = 1, right = 1 },
  },
  win_options = {
    winblend = 0,
    winhighlight = "NormalSB:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine",
  },
}

---Returns the node's position in the menu.
---@param node NuiTreeNode
---@param menu NuiMenu
---@return number|nil
local function find_item_in_menu(node, menu)
  local pos = nil
  for i, val in ipairs(menu.tree.nodes.root_ids) do
    if val == node:get_id() then
      pos = i
    end
  end
  return pos
end

---@param item NuiTreeNode
---@param menu NuiMenu
local function on_expand(item, menu)
  ---@type ht.right_click.MenuItem
  local menu_item = item.menu_item
  local menu_context = menu.menu_props.menu_context

  local pos = find_item_in_menu(item, menu)
  assert(pos ~= nil, "Item must be in menu")
  local display_options = {
    init_winnr = menu_context.display_options.init_winnr,
    row = menu_context.display_options.row + pos - 1,
    col = menu_context.display_options.col + menu.win_config.width + 4,
  }
  ---@type ht.right_click.Menu
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
    close = { "<ESC>", "<C-c>", "q" },
    submit = { "<CR>" },
  },
  on_change = function(item, menu)
    ---@type ht.right_click.MenuItem
    local menu_context = menu.menu_props.menu_context
    if menu_context.keymaps == nil then
      for linenr = 1, #menu.tree.nodes.root_ids do
        local node, target_linenr = menu.tree:get_node(linenr)
        if not menu._.should_skip_item(node) then
          ---@type ht.right_click.MenuItem
          local menu_item = node.menu_item

          for key, v in pairs(menu_item.keys) do
            if v then
              menu:map("n", key, function()
                vim.api.nvim_win_set_cursor(menu.winid, { target_linenr, 0 })
                menu._.on_change(node)
                if menu_item.children ~= nil and #menu_item.children > 0 then
                  -- expand
                  on_expand(node, menu)
                else
                  -- submit
                  menu.menu_props.on_submit(node)
                end
              end, { noremap = true, nowait = true })
            end
          end
        end
      end
      menu_context.keymaps = true
    end

    ---@type ht.right_click.MenuItem
    local menu_item = item.menu_item

    menu_item.rendering_context.in_menu = menu
    if menu_item.desc ~= nil then
      print(menu_item.desc)
    else
      print("\n\n")
    end
  end,
  on_submit = function(item)
    ---@type ht.right_click.MenuItem
    local menu_item = item.menu_item
    local menu = menu_item.rendering_context.in_menu
    local menu_context = menu.menu_props.menu_context

    -- close all previous menus
    local parent = menu_context.parent
    while parent ~= nil do
      parent:unmount()
      parent = parent.menu_props.menu_context.parent
    end

    vim.api.nvim_set_current_win(menu_context.display_options.init_winnr)

    if menu_item.callback ~= nil then
      menu_item.callback()
    end
  end,
}

---Calculate the width of the longest text in the given items.
---@param items ht.right_click.MenuItem[]
---@return number
local function max_text_width(items)
  local max_width = 20
  for _, item in ipairs(items) do
    max_width = math.max(max_width, item:length())
  end
  return max_width
end

---@return ht.right_click.MenuDisplayOptions
local function initialize_options()
  local first_line = vim.fn.line("w0")
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  local winnr = vim.api.nvim_get_current_win()
  r = r - first_line + 2
  c = c + 8
  return { init_winnr = winnr, row = r, col = c }
end

---@param opts ht.right_click.MenuDisplayOptions?
---@param parent NuiMenu?
function ContextMenu:as_nui_menu(opts, parent)
  opts = opts or initialize_options()
  local nui_menu = require("nui.menu")

  local popup_options = vim.tbl_extend("force", default_popup_options, {
    position = { row = opts.row, col = opts.col },
    relative = { winid = opts.init_winnr, type = "win" },
  })
  if parent ~= nil then
    popup_options.zindex = parent.win_config.zindex + 2
  end
  local text_width = max_text_width(self.items)
  local lines = UtilsTable.list_map_filter(self.items, function(item)
    return item:as_nui_node(text_width)
  end)
  local menu_options = vim.tbl_extend("force", default_menu_options, {
    lines = lines,
    on_close = function()
      if parent == nil then
        vim.api.nvim_set_current_win(opts.init_winnr)
      else
        vim.api.nvim_set_current_win(parent.winid)
      end
    end,
  })

  ---@type NuiMenu
  local menu = nui_menu(popup_options, menu_options)
  menu.menu_props.menu_context = { display_options = opts, parent = parent }

  -- define keymaps
  menu:map("n", "h", function()
    menu.menu_props.on_close()
  end, { noremap = true, nowait = true })
  menu:map("n", "l", function()
    local item = menu.tree:get_node()
    ---@type ht.right_click.MenuItem
    local menu_item = item.menu_item
    if menu_item.children ~= nil and #menu_item.children > 0 then
      on_expand(item, menu)
    end
  end, { noremap = true, nowait = true })

  return menu
end

return ContextMenu
