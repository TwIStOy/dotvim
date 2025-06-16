local M = {}

-- Import components module
local components = require("dotvim.configs.lualine_components")
local utils = require("dotvim.configs.lualine_components.utils")
local icon = require("dotvim.commons.icon")

-- Main configuration function
function M.setup()
  local lualine = require("lualine")
  
  lualine.setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "alpha", "starter" },
      },
      always_divide_middle = true,
      padding = 0,
      refresh = {
        statusline = 2000,
      },
    },
    sections = {
      lualine_a = {
        components.get("space"),
        components.get("mode"),
      },
      lualine_b = { 
        components.get("space"),
      },
      lualine_c = {
        components.get("cwd"),
        components.get("file"),
        components.get("space"),
        components.get("branch"),
        components.get("diff"),
        components.get("space"),
        components.get("macro"),
        components.get("search_count"),
      },
      lualine_x = {
        components.get("lsp_progress"),
        components.get("space"),
        components.get("diagnostics"),
      },
      lualine_y = {
        components.get("space"),
      },
      lualine_z = { 
        components.get("lsp_servers"),
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { components.get("file") },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      {
        filetypes = { "neo-tree" },
        sections = {
          lualine_a = {
            components.get("cwd"),
          },
        },
      },
      {
        filetypes = { "toggleterm" },
        sections = {
          lualine_a = {
            {
              function()
                return icon.get("Terminal", 1) .. "ToggleTerm #" .. vim.b.toggle_number
              end,
              separator = { left = "", right = "" },
            },
          },
          lualine_b = {
            components.get("space"),
          },
          lualine_c = {
            components.get("cwd"),
            {
              function()
                return vim.fn.getcwd()
              end,
              color = {
                bg = utils.resolve_bg("CursorLine"),
                fg = utils.resolve_fg("Normal"),
              },
              separator = { left = "", right = "" },
              padding = { left = 1 },
            },
          },
        },
      },
      {
        filetypes = { "lazy" },
        sections = {
          lualine_a = {
            {
              function()
                return icon.get("Package", 1) .. "lazy"
              end,
              separator = { left = "", right = "" },
            },
          },
          lualine_b = {
            {
              function()
                local ok, lazy = pcall(require, "lazy")
                if not ok then
                  return ""
                end
                return "loaded: "
                  .. lazy.stats().loaded
                  .. "/"
                  .. lazy.stats().count
              end,
              padding = { left = 1 },
              separator = { left = "", right = "" },
            },
          },
          lualine_c = {
            {
              function()
                local ok, lazy_status = pcall(require, "lazy.status")
                if not ok then
                  return ""
                end
                return lazy_status.updates()
              end,
              cond = function()
                local ok, lazy_status = pcall(require, "lazy.status")
                if not ok then
                  return false
                end
                return lazy_status.has_updates()
              end,
              separator = { left = "", right = "" },
            },
          },
        },
      },
    },
  })
end

return M
