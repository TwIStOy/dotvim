-- Lualine components module
local M = {}

-- Component loaders
M.cwd = require("dotvim.configs.lualine_components.cwd")
M.file = require("dotvim.configs.lualine_components.file")
M.lsp_progress = require("dotvim.configs.lualine_components.lsp_progress")
M.lsp_servers = require("dotvim.configs.lualine_components.lsp_servers")
M.branch = require("dotvim.configs.lualine_components.branch")
M.diff = require("dotvim.configs.lualine_components.diff")
M.diagnostics = require("dotvim.configs.lualine_components.diagnostics")
M.mode = require("dotvim.configs.lualine_components.mode")
M.space = require("dotvim.configs.lualine_components.space")
M.search_count = require("dotvim.configs.lualine_components.search_count")
M.macro = require("dotvim.configs.lualine_components.macro")
M.copilot = require("dotvim.configs.lualine_components.copilot")

-- Helper function to get a component by name
function M.get(name)
  local component = M[name]
  if component and type(component) == "function" then
    return component()
  else
    error("Component '" .. name .. "' not found or is not a function")
  end
end

return M
