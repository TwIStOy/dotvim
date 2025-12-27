local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Component: Current working directory
local function create_component()
  local current_cwd

  local function refresh_current_cwd()
    local dir = vim.fn.getcwd()
    local home = os.getenv("HOME")
    if home then
      local match = string.find(dir, home, 1, true)
      if match == 1 then
        dir = "~" .. string.sub(dir, #home + 1)
      end
    end
    current_cwd = icon.get("FolderOpen", 1) .. dir
  end

  vim.api.nvim_create_autocmd({
    "VimEnter",
    "DirChanged",
  }, {
    callback = function()
      refresh_current_cwd()
    end,
  })

  return {
    function()
      if not current_cwd then
        refresh_current_cwd()
      end
      return current_cwd
    end,
    color = {
      bg = utils.resolve_fg("String"),
      fg = utils.resolve_fg("IncSearch"),
    },
    separator = { left = "", right = "" },
  }
end

return create_component
