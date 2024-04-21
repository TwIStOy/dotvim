---@class dotvim.extra.ui.copilot_chat
local M = {}

function M.toggle()
  if M.renderer then
    return M.renderer:focus()
  end

  local n = require("nui-components")

  local win_width = vim.o.columns
  local win_height = vim.o.lines

  local width = math.floor(win_width * 0.6)
  local height = math.floor(win_height * 0.8)

  local renderer = n.create_renderer {
    width = width,
    height = 3,
    -- relative = "editor",
    -- position = {
    --   row = math.floor((win_height - height) / 2),
    --   col = math.floor((win_width - width) / 2),
    -- },
  }

  local signal = n.create_signal {
    prompt = "",
    is_preview_visible = false,
  }

  local buf = vim.api.nvim_create_buf(false, true)

  local body = function()
    return n.rows(
      n.text_input {
        border_label = "Prompt",
        autofocus = true,
        wrap = true,
        on_change = function(value)
          signal.prompt = value
        end,
      },
      n.buffer {
        id = "preview",
        flex = 1,
        buf = buf,
        autoscroll = true,
        border_label = "Preview",
        hidden = signal.is_preview_visible:negate(),
      }
    )
  end

  renderer:add_mappings {
    {
      mode = { "n", "i" },
      key = "<D-CR>",
      handler = function()
        local chat = require("CopilotChat")
        local state = signal:get_value()

        renderer:set_size { height = 20 }
        signal.is_preview_visible = true

        renderer:schedule(function()
          chat.ask("Show me something interesting", {
            callback = function(response)
              -- move cursor to the end of the buffer
              local win_id = renderer:get_component_by_id("preview").winid
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local col = #lines[#lines]
              vim.api.nvim_win_set_cursor(
                win_id,
                { vim.api.nvim_buf_line_count(buf), col }
              )
              vim.api.nvim_put({ response }, "l", false, true)
            end,
          })
        end)
      end,
    },
  }

  M.renderer = renderer

  renderer:render(body)
end

return M
