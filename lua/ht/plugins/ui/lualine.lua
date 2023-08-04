local M = {}

local fn = vim.fn
local with_lsp = require("ht.with_plug.lsp")

M = {
  "hoob3rt/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

local available_sep_icons = {
  default = { left = "", right = "" },
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
  arrow = { left = "", right = "" },
}

local options = {
  component_separators = { left = "|", right = "|" },
  section_separators = {
    left = available_sep_icons.default.right,
    right = "",
  },

  theme = "auto",
  globalstatus = true,
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { "filename" },
  lualine_x = { "location" },
  lualine_y = {},
  lualine_z = {},
}

local function get_cwd()
  local cwd = vim.fn.getcwd()
  local home = os.getenv("HOME")
  if cwd:find(home, 1, true) == 1 then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return "  " .. cwd
end

local function rime_state()
  if vim.g.global_rime_enabled then
    return "ㄓ"
  else
    return ""
  end
end

local function fg(group)
  local color = vim.api.nvim_get_hl(0, { name = group }).fg
  if color ~= nil and color ~= "" then
    return string.format("#%x", color)
  end
  return ""
end

local components = {}

components.mode = {
  "mode",
  icons_enabled = true,
  icon = {
    " ",
    align = "left",
  },
}

components.fileinfo = {
  function()
    local icon = "󰈚 "
    local filename = (fn.expand("%") == "" and "Empty ")
      or fn.fnamemodify(fn.expand("%"), ":.")

    if filename ~= "[Empty]" then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
        local ft_icon = devicons.get_icon(filename)
        icon = (ft_icon ~= nil and ft_icon .. " ") or ""
        if fn.expand("%:e") == "md" then
          icon = icon .. " "
        end
      end
    end
    return icon .. filename
  end,
}

components.lsp_progress = {
  with_lsp.progress,
}

M.config = function() -- code to run after plugin loaded
  require("lualine").setup {
    options = options,
    sections = {
      lualine_a = { components.mode },
      lualine_b = {
        get_cwd,
        components.lsp_progress,
      },
      lualine_c = {
        {
          function()
            return "%="
          end,
          separator = "",
        },
        {
          components.fileinfo[1],
          separator = "",
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          sections = { "error", "warn", "info", "hint" },
          diagnostics_color = {
            error = { fg = fg("DiagnosticError") },
            warn = { fg = fg("DiagnosticWarn") },
            info = { fg = fg("DiagnosticInfo") },
            hint = { fg = fg("DiagnosticHint") },
          },
          symbols = {
            error = " ",
            warn = " ",
            info = "󰛩 ",
            hint = " ",
          },
          colored = true,
          update_in_insert = false,
          always_visible = false,
        },
      },
      lualine_x = { "branch", "diff" },
      lualine_y = {
        { rime_state },
        { "filetype", colored = true, icon_only = false },
      },
      lualine_z = {
        "progress",
        {
          "location",
          -- separator = { right = available_sep_icons.round.right },
        },
      },
    },
    inactive_sections = inactive_sections,
    tabline = {},
    extensions = {},
  }
end

return M
