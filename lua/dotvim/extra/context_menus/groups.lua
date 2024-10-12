---@class dotvim.extra.context_menus.groups
local M = {}

---@return dotvim.extra.ContextMenuOption
function M.build_plugin_refactor()
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = 0,
  })

  local contexts = require("refactor.actions").create_context(ft)

  ---@type dotvim.extra.ContextMenuOptions
  local ret = {}

  for _, ctx in ipairs(contexts) do
    if ctx.available() then
      ret[#ret + 1] = {
        name = ctx.name,
        cmd = function()
          vim.schedule(function()
            ctx.do_refactor()
          end)
        end,
      }
    end
  end

  ---@type dotvim.extra.ContextMenuOption
  return {
    name = "Refactor",
    items = ret,
  }
end

return M
