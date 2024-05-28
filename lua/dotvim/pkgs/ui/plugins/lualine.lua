local fix_formatters_name = {
  ["clang_format"] = "clang-format",
}

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
  local buf_clients = vim.lsp.get_clients {
    bufnr = 0,
  }
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" and client.name ~= "copilot" then
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
  if ok then
    for _, formatter in ipairs(conform.list_formatters_for_buffer()) do
      if formatter then
        table.insert(
          buf_client_names,
          vim.F.if_nil(fix_formatters_name[formatter], formatter)
        )
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

local function get_focused_term()
  local ok, Terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    return nil
  end
  local focused_id = Terminal.get_focused_id()
  if focused_id == nil then
    return nil
  end
  local focused = Terminal.get(focused_id, false)
  if focused == nil then
    return nil
  end
  return focused
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
      draw_empty = true,
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
        bg = resolve_fg("String"),
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
        bg = resolve_fg("Type"),
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
        {
          filetypes = { "neo-tree" },
          sections = {
            lualine_a = {
              get_component("cwd"),
            },
          },
        },
        {
          filetypes = { "toggleterm" },
          sections = {
            lualine_a = {
              {
                function()
                  return "ToggleTerm #" .. vim.b.toggle_number
                end,
                separator = { left = "", right = "" },
              },
            },
            lualine_b = {
              space,
            },
            lualine_c = {
              {
                function()
                  local term = get_focused_term()
                  if not term then
                    return ""
                  end
                  local dir = term.dir
                  local home = os.getenv("HOME") --[[@as string]]
                  local match = string.find(dir, home, 1, true)
                  if match == 1 then
                    dir = "~" .. string.sub(dir, #home + 1)
                  end
                  return Utils.icon.predefined_icon("FolderOpen", 1) .. dir
                end,
                color = {
                  bg = Utils.vim.resolve_fg("Macro"),
                  fg = Utils.vim.resolve_bg("Normal"),
                  gui = "bold",
                },
                separator = { left = "", right = "" },
              },
              {
                function()
                  local term = get_focused_term()
                  if not term then
                    return ""
                  end
                  return term.cmd
                end,
                color = {
                  bg = Utils.vim.resolve_bg("CursorLine"),
                  fg = Utils.vim.resolve_fg("Normal"),
                },
                separator = { left = "", right = "" },
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
                  return "lazy 💤"
                end,
                separator = { left = "", right = "" },
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
                separator = { left = "", right = "" },
              },
            },
            lualine_c = {
              {
                require("lazy.status").updates,
                cond = require("lazy.status").has_updates,
                separator = { left = "", right = "" },
              },
            },
          },
        },
      },
    }
  end,
}
