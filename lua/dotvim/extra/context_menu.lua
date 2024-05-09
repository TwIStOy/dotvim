---@class dotvim.extra.context_menu
local M = {}

local new_item = require("dotvim.extra.ui.context_menu.item")
---@type dotvim.extra.ui.context_menu.ContextMenu
local ContextMenu = require("dotvim.extra.ui.context_menu.menu")

---@return dotvim.extra.ui.context_menu.MenuItem[]
local function build_nodes_from_refactor()
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = 0,
  })
  local contexts = require("refactor.actions").create_context(ft)
  return vim
    .iter(contexts)
    :map(function(ctx)
      return {
        ctx.name,
        callback = function()
          vim.schedule(function()
            ctx.do_refactor()
          end)
        end,
        disabled = not ctx.available(),
      }
    end)
    :totable()
end

---@return dotvim.extra.ui.context_menu.MenuItem[]
local function build_nodes()
  return {
    new_item {
      "&Refactor",
      children = build_nodes_from_refactor(),
    },
  }
end

M.open_context_menu = function()
  local menu = ContextMenu.construct()
  menu:init(build_nodes())
  menu:mount(true)
end

return M
