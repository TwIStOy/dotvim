---@class dotvim.extra.ui.copilot_chat
local M = {}

function M.toggle()
  if M.renderer then
    return M.renderer:focus()
  end

  local n = require("nui-components")
  local chat = require("CopilotChat")

  local win_width = vim.o.columns
  local win_height = vim.o.lines

  local width = math.floor(win_width * 0.6)
  local height = math.floor(win_height * 0.8)

  local renderer = n.create_renderer {
    width = width,
    height = height,
    relative = "editor",
    position = {
      row = math.floor((win_height - height) / 2),
      col = math.floor((win_width - width) / 2),
    },
  }

  local signal = n.create_signal {
    prompt = "",
  }

  local buttons = function()
    return n.columns {
      n.button {
        text = "Send",
        on_click = function()
          local prompt = signal:get("prompt")
          if prompt == "" then
            return
          end

          vim.api.nvim_command("CopilotChat send " .. prompt)
          signal:set("prompt", "")
        end,
      },
      n.button {
        text = "Close",
        on_click = function()
          renderer:close()
        end,
      },
    }
  end
end

return M
