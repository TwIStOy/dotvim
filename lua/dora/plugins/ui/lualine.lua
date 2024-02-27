---@type dora.core.plugin.PluginOptions
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    ---@type dora.config
    local config = require("dora.config")

    local function cwd()
      local dir = vim.fn.getcwd()
      local home = os.getenv("HOME") --[[@as string]]
      local match = string.find(dir, home, 1, true)
      if match == 1 then
        dir = "~" .. string.sub(dir, #home + 1)
      end
      return config.icon.predefined_icon("FolderOpen", 1) .. dir
    end

    local function fileinfo()
      local icon = "󰈚 "
      local currentFile = vim.fn.expand("%")
      local filename
      if currentFile == "" then
        filename = "Empty "
      else
        filename = vim.fn.fnamemodify(currentFile, ":.")
        local deviconsPresent, devicons = pcall(require, "nvim-web-devicons")
        if deviconsPresent then
          local ftIcon = devicons.get_icon(filename)
          if ftIcon ~= nil then
            icon = ftIcon .. " "
          end
          if vim.fn.expand("%:e") == "md" then
            icon = icon .. " "
          end
        end
      end
      return icon .. filename
    end

    return {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icons_enabled = true,
            icon = {
              config.icon.predefined_icon("VimLogo", 1),
              align = "left",
            },
          },
        },
        lualine_b = { cwd },
        lualine_c = {
          { fileinfo, separator = "" },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = config.icon.predefined_icon("DiagnosticError", 1),
              warn = config.icon.predefined_icon("DiagnosticWarn", 1),
              info = config.icon.predefined_icon("DiagnosticInfo", 1),
              hint = config.icon.predefined_icon("DiagnosticHint", 1),
            },
          },
          "branch",
          "diff",
        },
        lualine_y = {
          { "filetype", colored = true, icon_only = false },
        },
        lualine_z = { "progress", "location" },
      },
      tabline = {},
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
