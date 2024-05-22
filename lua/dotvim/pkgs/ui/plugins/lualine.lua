local function resolve_fg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil or info.fg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.fg)
end

local function resolve_bg(group)
  local info = vim.api.nvim_get_hl(0, {
    name = group,
    create = false,
  })
  if info == nil or info.bg == nil then
    return "NONE"
  end
  return string.format("#%06x", info.bg)
end

local function getLspName()
  local buf_clients = vim.lsp.buf_get_clients()
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" or client.name == "copilot" then
      table.insert(buf_client_names, client.name)
    end
  end

  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local ok, conform = pcall(require, "conform")
  local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
  if ok then
    for formatter in formatters:gmatch("%w+") do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ", ")
  return language_servers
end

---@type dotvim.core.plugin.PluginOption
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
    ---@type dotvim.utils
    local Utils = require("dotvim.utils")

    local space = {
      function()
        return " "
      end,
      color = { bg = resolve_bg("Normal"), fg = resolve_bg("Normal") },
      separator = { left = "", right = "" },
      padding = 0,
    }

    local function get_component(name)
      return require("dotvim.pkgs.ui.lualine_components." .. name)
    end

    local lsp = {
      function()
        return getLspName()
      end,
      separator = { left = "", right = "" },
      color = {
        bg = resolve_fg("@parameter"),
        fg = resolve_bg("Normal"),
        gui = "italic,bold",
      },
    }

    local mode = {
      "mode",
      icons_enabled = true,
      icon = {
        Utils.icon.predefined_icon("VimLogo", 1),
        align = "left",
      },
      separator = { left = "", right = "" },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = Utils.icon.predefined_icon("DiagnosticError", 1),
        warn = Utils.icon.predefined_icon("DiagnosticWarn", 1),
        info = Utils.icon.predefined_icon("DiagnosticInfo", 1),
        hint = Utils.icon.predefined_icon("DiagnosticHint", 1),
      },
      color = {
        bg = resolve_bg("CursorLine"),
        fg = resolve_bg("ModesInsert"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
      padding = 1,
    }

    local lsp_progress = {
      function()
        local ok, lsp_progress = pcall(require, "lsp-progress")
        if not ok then
          return ""
        end
        return lsp_progress.progress {
          max_size = 80,
          format = function(messages)
            if #messages > 0 then
              return table.concat(messages, " ")
            end
            return ""
          end,
        }
      end,
      separator = { left = "", right = "" },
      color = {
        bg = resolve_bg("CursorLine"),
        fg = resolve_fg("Comment"),
        gui = "bold",
      },
    }

    local diff = {
      "diff",
      color = {
        bg = resolve_bg("CursorLine"),
        fg = resolve_bg("Normal"),
        gui = "bold",
      },
      padding = { left = 1 },
      separator = { left = "", right = "" },
      symbols = {
        added = Utils.icon.predefined_icon("GitAdd", 1),
        modified = Utils.icon.predefined_icon("GitChange", 1),
        removed = Utils.icon.predefined_icon("GitDelete", 1),
      },
    }

    local branch = {
      "branch",
      icon = "",
      color = {
        bg = resolve_fg("Keyword"),
        fg = resolve_bg("Normal"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
    }

    return {
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
      },
      sections = {
        lualine_a = {
          mode,
        },
        lualine_b = { space },
        lualine_c = {
          get_component("cwd"),
          get_component("file"),
          space,
          branch,
          diff,
        },
        lualine_x = {
          lsp_progress,
          space,
          diagnostics,
        },
        lualine_y = {
          space,
        },
        lualine_z = { lsp },
      },
      tabline = {},
      extensions = {
        "lazy",
        {
          filetypes = { "neo-tree" },
          sections = {
            lualine_a = {
              get_component("cwd"),
            },
          },
        },
      },
    }
  end,
}
