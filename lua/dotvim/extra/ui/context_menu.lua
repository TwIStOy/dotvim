---@class dotvim.extra.ui.context_menu
local M = {}

---@type dotvim.utils
local Utils = require("dotvim.utils")

local n = require("nui-components")

---@class dotvim.extra.ui.context_menu.MenuItem
---@field name string
---@field icon? string
---@field disabled? boolean
---@field do_action? fun()
---@field children? dotvim.extra.ui.context_menu.MenuItem[]

---@class dotvim.extra.ui.context_menu.ItemGroup
---@field name string
---@field items dotvim.extra.ui.context_menu.MenuItem[]

---@param items dotvim.extra.ui.context_menu.MenuItem[]
local function get_max_width(items)
  local max_width = 20 -- at least 20
  for _, item in ipairs(items) do
    local width = #item.name
    if item.icon ~= nil then
      width = width + #item.icon + 1
    end
    if item.children ~= nil then
      width = width + 2 -- " "
    end
    max_width = math.max(max_width, #item.name)
  end
  return max_width
end

---@param groups dotvim.extra.ui.context_menu.ItemGroup[]
local function open_context_menu(groups)
  local width = vim
    .iter(groups)
    :map(function(group)
      return get_max_width(group.items)
    end)
    :fold(20, function(acc, v)
      return math.max(acc, v)
    end)
  local height = vim
    .iter(groups)
    :map(function(group)
      return #group.items
    end)
    :fold(#groups - 1, function(acc, v)
      return acc + v
    end)

  local renderer = n.create_renderer {
    width = width + 2,
    height = height + 2,
  }

  local body = function()
    local nodes = vim
      .iter(groups)
      :enumerate()
      :map(function(i, group)
        local ret = {}
        if i > 1 then
          ret[#ret + 1] = n.separator()
        end
        vim.list_extend(
          ret,
          vim
            .iter(group.items)
            :map(function(item)
              return n.node {
                ctx = item,
              }
            end)
            :totable()
        )
        return ret
      end)
      :flatten()
      :totable()

    return n.tree({
      autofocus = true,
      data = nodes,
      border_style = "single",
      ---@param ctx {ctx: dotvim.extra.ui.context_menu.MenuItem}
      ---@diagnostic disable-next-line: unused-local
      on_select = function(ctx, component)
        ctx.ctx.do_action()
        renderer:close()
      end,
      ---@param ctx {ctx: dotvim.extra.ui.context_menu.MenuItem}
      ---@diagnostic disable-next-line: unused-local
      on_change = function(ctx, component)
        if ctx.ctx.children ~= nil then
          -- open next menu
          open_context_menu { { name = ctx.ctx.name, items = ctx.ctx.children } }
        end
      end,
      ---@param ctx {ctx: dotvim.extra.ui.context_menu.MenuItem}
      ---@diagnostic disable-next-line: unused-local
      prepare_node = function(ctx, line, component)
        local text = ""
        if ctx.ctx.icon ~= nil then
          text = text .. ctx.ctx.icon .. " "
        end
        text = text .. ctx.ctx.name
        if ctx.ctx.children ~= nil then
          text = text .. " "
        end
        if ctx.ctx.disabled == true then
          line:append(text, "Comment")
        else
          line:append(text)
        end
        return line
      end,
      ---@param ctx {ctx: dotvim.extra.ui.context_menu.MenuItem}
      should_skip_item = function(ctx)
        return ctx.ctx.disabled == true
      end,
    }, {
      relative = "cursor",
      position = {
        row = 1,
        col = 0,
      },
    })
  end

  renderer:render(body)
end

M.open_context_menu = function()
  local expand_binding =
    require("refactor.actions.nix").expand_binding.create_context()

  ---@type dotvim.extra.ui.context_menu.ItemGroup[]
  local groups = {
    {
      name = "Refactor (r)",
      items = {
        {
          name = "Expand",
          icon = "󰘖 ",
          do_action = function()
            expand_binding.do_refactor()
          end,
          disabled = not expand_binding.available(),
        },
      },
    },
  }

  open_context_menu(groups)
end

return M
