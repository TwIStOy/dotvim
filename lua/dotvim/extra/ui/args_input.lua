---@class dotvim.extra.ui.args_input
local M = {}

---@param cmd string|fun(string):any
---@return fun():any
function M.input_args(cmd)
  local n = require("nui-components")
  local hint
  if type(cmd) == "string" then
    hint = "arguments to " .. cmd
  else
    hint = "arguments"
  end

  return function()
    local renderer = n.create_renderer {
      width = 60,
      height = 3,
    }

    local body = function()
      return n.prompt {
        autofocus = true,
        mappings = function()
          return {
            {
              mode = { "n", "i", "v" },
              key = { "<Esc>" },
              handler = function()
                renderer:close()
              end,
            },
          }
        end,
        prefix = " > ",
        border_label = {
          text = hint,
          align = "center",
        },
        on_submit = function(value)
          if type(cmd) == "string" then
            pcall(vim.api.nvim_command, cmd .. " " .. value)
          else
            pcall(cmd, value)
          end
          vim.schedule(function()
            renderer:close()
          end)
        end,
      }
    end

    renderer:render(body)
  end
end

return M
