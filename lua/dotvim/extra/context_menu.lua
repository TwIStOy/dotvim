---@class dotvim.extra.context_menu
local M = {}

local function build_nodes()
end

M.open_context_menu = function()
  local expand_binding =
    require("refactor.actions.nix").expand_binding.create_context()

  local groups = {
    {
      name = "Refactor (r)",
      items = {
        {
          name = "Refactor",
          children = {
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
      },
    },
  }
end

return M
