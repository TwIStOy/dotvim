local utils = require("dotvim.configs.lualine_components.utils")

-- Component: LSP progress
local function create_component()
  local current_message = ""

  local function update_message()
    local ok, lsp_progress = pcall(require, "lsp-progress")
    if not ok then
      current_message = ""
      return
    end
    current_message = lsp_progress.progress {
      max_size = 80,
      format = function(messages)
        if #messages > 0 then
          return table.concat(messages, " ")
        end
        return ""
      end,
    }
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "LspProgressStatusUpdated",
    callback = update_message,
  })

  return {
    function()
      return current_message or ""
    end,
    separator = { left = "", right = "" },
    color = {
      bg = utils.resolve_bg("CursorLine"),
      fg = utils.resolve_fg("Comment"),
      gui = "bold",
    },
  }
end

return create_component
