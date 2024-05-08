---@class dotvim.extra.ui.context_menu.ContextMenu
---@field render any
---@field parent? dotvim.extra.ui.context_menu.ContextMenu
---@field pos { row: integer, col: integer }
---@field nodes dotvim.extra.ui.context_menu.TreeNode[]
---@field current_node dotvim.extra.ui.context_menu.TreeNode
---@field sub? dotvim.extra.ui.context_menu.ContextMenu
---@field from_window? integer
local ContextMenu = {}

---@type dotvim.utils
local Utils = require("dotvim.utils")

local n = require("nui-components")

---@return dotvim.extra.ui.context_menu.ContextMenu
function ContextMenu.construct()
  return setmetatable({}, { __index = ContextMenu })
end

--- Close all existing renders.
function ContextMenu:close()
  self.render:close()
  if self.parent ~= nil then
    self.parent:close()
  end
end

function ContextMenu:close_subtree()
  if self.sub ~= nil then
    self.sub.parent = nil
    self.sub:close_subtree()
  end
  if self.parent ~= nil then
    self.parent.render:focus()
    self.parent.sub = nil
  end
  self.render:close()
end

---@class dotvim.extra.ui.context_menu.TreeNode
---@field item dotvim.extra.ui.context_menu.MenuItem
---@field idx integer

---@param width integer
local function make_prepare_node_func(width)
  ---@param node dotvim.extra.ui.context_menu.TreeNode
  ---@param line NuiLine
  return function(node, line)
    local hl = function(group)
      if node.item.disabled then
        return "Comment"
      end
      return group
    end

    if node.item.text.raw_text == "---" then
      local nui_menu = require("nui.menu")
      return nui_menu.separator(nil, { "-" })
    end

    local text = node.item.text:into_nui_line(not not node.item.disabled, line)
    local length = node.item.text:length()
    if node.item.extra_keys ~= nil and #node.item.extra_keys > 0 then
      local hint = table.concat(node.item.extra_keys, "|")
      -- always reserve 2 spaces for arrow
      local space_count = width - 2 - length - #hint
      if space_count > 0 then
        text:append(string.rep(" ", space_count))
      end
      text:append(hint, hl("key"))
      length = length + space_count + #hint
    end

    if
      node.item.children ~= nil
      and #node.item.children > 0
      and width ~= nil
    then
      local spaces = width - length - 2
      if spaces > 0 then
        text:append(string.rep(" ", spaces), hl("Normal"))
      end
      text:append("▶", hl("Normal"))
    elseif width ~= nil then
      text:append(string.rep(" ", width - length), hl("Normal"))
    end

    return text
  end
end

---@param node dotvim.extra.ui.context_menu.TreeNode
local function should_skip_item(node)
  if node.item.text.raw_text == "---" then
    return true
  end
  if node.item.disabled then
    return true
  end
  return false
end

---@class dotvim.extra.ui.context_menu.ParentOpts
---@field parent dotvim.extra.ui.context_menu.ContextMenu
---@field from_index integer

---@param items dotvim.extra.ui.context_menu.MenuItem[]
---@param parent? dotvim.extra.ui.context_menu.ParentOpts
function ContextMenu:init(items, parent)
  local nodes = vim
    .iter(items)
    :enumerate()
    :map(function(idx, item)
      return n.node { item = item, idx = idx }
    end)
    :totable()
  local width = vim
    .iter(items)
    :map(function(item)
      return item.text:length()
    end)
    :fold(20, function(acc, v)
      return math.max(acc, v)
    end)
  local height = #items

  if parent == nil then
    local row, col = Utils.vim.cursor0_to_editor()
    self.pos = { row = row + 2, col = col }
    self.from_window = vim.api.nvim_get_current_win()
  else
    self.parent = parent.parent
    self.pos = vim.deepcopy(parent.parent.pos)
    self.pos.row = self.pos.row + parent.from_index - 1
    self.pos.col = self.pos.col + self.parent.render:get_size().width
  end
  self.render = n.create_renderer {
    width = width + 2,
    height = height + 2,
    relative = "editor",
    position = self.pos,
  }
  if parent == nil then
    self.render:on_unmount(function()
      vim.api.nvim_set_current_win(self.from_window)
      if self.sub ~= nil then
        self.sub.parent = nil
        self.sub:close_subtree()
      end
    end)
  else
    self.render:on_unmount(function()
      if self.sub ~= nil then
        self.sub.parent = nil
        self.sub:close_subtree()
      end
    end)
  end
  self.render:add_mappings {
    {
      mode = "n",
      key = "h",
      handler = function()
        self:close_subtree()
      end,
    },
    {
      mode = "n",
      key = "l",
      handler = function()
        if self.sub ~= nil then
          local components = self.sub.render:get_focusable_components()
          if components ~= nil and #components > 0 then
            components[1]:focus()
          end
        end
      end,
    },
  }
  self.nodes = nodes
  self.current_node = nodes[1]
end

function ContextMenu:mount(focus)
  ---@param node dotvim.extra.ui.context_menu.TreeNode
  ---@param component any
  ---@diagnostic disable-next-line: unused-local
  local on_change = function(node, component)
    self.current_node = node
    if self.sub ~= nil then
      self.sub:close_subtree()
    end
    local children = node.item.children
    if children == nil or #children == 0 then
      return
    end
    -- construct a new menu
    local sub_menu = ContextMenu.construct()
    sub_menu:init(children, { parent = self, from_index = node.idx })
    sub_menu:mount(false)
    self.sub = sub_menu
  end

  ---@param node dotvim.extra.ui.context_menu.TreeNode
  ---@param component any
  ---@diagnostic disable-next-line: unused-local
  local on_select = function(node, component)
    if node.item.callback ~= nil then
      node.item.callback()
      self:close()
    else
      on_change(node, component)
    end
  end

  local body = function()
    return n.tree {
      autofocus = focus,
      border_style = "single",
      window = {
        highlight = "Normal:Normal",
      },
      data = self.nodes,
      on_select = on_select,
      on_change = on_change,
      prepare_node = make_prepare_node_func(self.render:get_size().width - 2),
      should_skip_item = should_skip_item,
    }
  end
  self.render:render(body)
end

return ContextMenu
