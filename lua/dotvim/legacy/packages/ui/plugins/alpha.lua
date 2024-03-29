---@type dora.core.plugin.PluginOption[]
return {
  {
    "goolord/alpha-nvim",
    cond = function()
      return vim.fn.argc() == 0
        and vim.o.lines >= 36
        and vim.o.columns >= 80
        and not vim.g.vscode
    end,
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      ---@type dora.lib
      local lib = require("dora.lib")
      ---@type dora.config
      local config = require("dora.config")

      local redraw_alpha_autocmd = nil

      local function clear_autocmd()
        if redraw_alpha_autocmd then
          vim.api.nvim_del_autocmd(redraw_alpha_autocmd)
          redraw_alpha_autocmd = nil
        end
      end

      ---@param sc string
      ---@param txt string|fun(): string
      ---@param callback string|fun():any
      ---@param opts? table
      local function make_button(sc, txt, callback, opts)
        opts = opts or {}
        local on_press = lib.func.normalize_callback(
          callback,
          vim.F.if_nil(opts.feedkeys, true)
        )
        opts = vim.tbl_extend("force", {
          position = "center",
          shortcut = sc,
          cursor = 3,
          width = 50,
          align_shortcut = "right",
          hl_shortcut = "Keyword",
          keymap = {
            "n",
            sc,
            "",
            {
              noremap = true,
              silent = true,
              nowait = true,
              callback = function()
                on_press()
                if opts.close_on_press then
                  clear_autocmd()
                end
              end,
            },
          },
        }, opts)
        return {
          type = "button",
          val = txt,
          on_press = opts.keymap[4].callback,
          opts = opts,
        }
      end

      ---@param filename string
      ---@return string
      local function get_extension(filename)
        local match = filename:match("^.+(%..+)$")
        local ext = ""
        if match ~= nil then
          ext = match:sub(2)
        end
        return ext
      end

      ---@param filename string
      ---@return string, string
      local function get_icon_highlight(filename)
        local nvim_web_devicons = require("nvim-web-devicons")
        local ext = get_extension(filename)
        return nvim_web_devicons.get_icon(filename, ext, { default = true })
      end

      ---@param filename string
      ---@param sc string short cut
      ---@param short_filename? string
      local function make_file_button(filename, sc, short_filename)
        local nvim_web_devicons = require("nvim-web-devicons")

        short_filename = short_filename or filename
        local icon, highlight = get_icon_highlight(filename)
        local button_highlights = {}
        if type(nvim_web_devicons.highlight) == "boolean" then
          if highlight and nvim_web_devicons.highlight then
            button_highlights[#button_highlights + 1] = {
              highlight,
              0,
              1,
            }
          end
        elseif type(nvim_web_devicons.highlight) == "string" then
          button_highlights[#button_highlights + 1] = {
            nvim_web_devicons.highlight,
            0,
            1,
          }
        end
        icon = icon .. "  "
        local fn_start = short_filename:match(".*/")
        if fn_start ~= nil then
          button_highlights[#button_highlights + 1] = {
            "Comment",
            #icon - 2,
            #fn_start + #icon,
          }
        end
        return make_button(sc, icon .. short_filename, "e " .. filename, {
          hl = button_highlights,
          feedkeys = false,
        })
      end

      ---@param sc string
      ---@param project_path string
      local function make_project_button(sc, project_path)
        local icon_txt = "  "
        local on_press = function()
          vim.api.nvim_command("cd " .. project_path)
          -- schedule a redraw to show recent files in project
          vim.schedule(function()
            require("alpha").redraw()
          end)
        end
        return make_button(
          sc,
          icon_txt .. vim.fn.fnamemodify(project_path, ":~"),
          on_press
        )
      end

      local function make_recent_files_buttons()
        local path = require("plenary.path")

        local function mru(start, cwd, items_number, opts)
          opts = opts
            or {
              ignore = function(p, ext)
                return (string.find(p, "COMMIT_EDITMSG"))
                  or (vim.tbl_contains({ "gitcommit" }, ext))
              end,
            }

          items_number = items_number or 9

          local oldfiles = {}
          for _, v in pairs(vim.v.oldfiles) do
            if #oldfiles == items_number then
              break
            end
            local cwd_cond
            if not cwd then
              cwd_cond = true
            else
              cwd_cond = vim.startswith(v, cwd)
            end
            local ignore = (opts.ignore and opts.ignore(v, get_extension(v)))
              or false
            if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
              oldfiles[#oldfiles + 1] = v
            end
          end

          local target_width = 35

          local tbl = {}
          for i, fn in ipairs(oldfiles) do
            local short_fn
            if cwd then
              short_fn = vim.fn.fnamemodify(fn, ":.")
            else
              short_fn = vim.fn.fnamemodify(fn, ":~")
            end

            if #short_fn > target_width then
              short_fn = path.new(short_fn):shorten(1, { -2, -1 })
              if #short_fn > target_width then
                short_fn = path.new(short_fn):shorten(1, { -1 })
              end
            end

            local special_shortcuts = { "a", "s", "d" }
            local shortcut = ""
            if i <= #special_shortcuts then
              shortcut = special_shortcuts[i]
            else
              shortcut = tostring(i + start - 1 - #special_shortcuts)
            end

            local file_button_el =
              make_file_button(fn, " " .. shortcut, short_fn)
            tbl[i] = file_button_el
          end
          return { type = "group", val = tbl, opts = {} }
        end

        return {
          {
            type = "text",
            val = "Recent files",
            opts = {
              hl = "SpecialComment",
              shrink_margin = false,
              position = "center",
            },
          },
          { type = "padding", val = 1 },
          {
            type = "group",
            val = function()
              return { mru(1, vim.fn.getcwd(), 5) }
            end,
            opts = { shrink_margin = false },
          },
        }
      end

      local function make_recent_project_buttons()
        local function _build_buttons()
          local recent_projects = lib.func.require_then(
            "project_nvim",
            function(project_nvim)
              return project_nvim.get_recent_projects()
            end
          ) or {}
          lib.tbl.list_reverse(recent_projects)

          local buttons = {}
          local special_shortcuts = { "a", "s", "d" }

          for i, project_path in ipairs(recent_projects) do
            if i > 5 then
              break
            end

            local shortcut = ""
            if i <= #special_shortcuts then
              shortcut = special_shortcuts[i]
            else
              shortcut = tostring(i - #special_shortcuts)
            end
            buttons[#buttons + 1] =
              make_project_button(" " .. shortcut, project_path)
          end

          return buttons
        end

        return {
          {
            type = "text",
            val = "Recent Projects",
            opts = {
              hl = "SpecialComment",
              shrink_margin = false,
              position = "center",
            },
          },
          { type = "padding", val = 1 },
          {
            type = "group",
            val = _build_buttons,
            opts = { shrink_margin = false },
          },
        }
      end

      local function make_recent_buttons()
        local cwd = vim.fn.getcwd()
        if cwd == "/" then
          return make_recent_project_buttons()
        else
          return make_recent_files_buttons()
        end
      end

      local function make_fortune_text()
        local stats = require("lazy").stats()
        return string.format(
          "󱐌 %d plugins loaded in %dms",
          stats.count,
          stats.startuptime
        )
      end

      local function make_header_liens()
        local lines = {}
        for i, line in ipairs(config.ui.dashboard_header) do
          lines[i] = {
            type = "text",
            val = line,
            opts = {
              hl = "StartLogo" .. i,
              position = "center",
              shrink_margin = false,
            },
          }
        end
        lines[#lines + 1] = {
          type = "text",
          val = "dora.version: " .. require("dora.version").version(),
          opts = {
            hl = "SpecialComment",
            position = "center",
          },
        }
        return {
          type = "group",
          val = lines,
          opts = {
            position = "center",
          },
        }
      end

      local function make_toolbar_buttons()
        local buttons = {
          {
            type = "text",
            val = "Quick Actions",
            opts = { hl = "SpecialComment", position = "center" },
          },
          { type = "padding", val = 1 },
        }

        buttons[#buttons + 1] =
          make_button("e", "󱪝  New File", ":ene <BAR> startinsert <CR>")

        if lib.vim.current_gui() ~= nil then
          buttons[#buttons + 1] =
            make_button("p", "  Projects", "PickRecentProject", {
              feedkeys = false,
            })
        end

        buttons[#buttons + 1] = make_button("q", "󰗼  Quit", function()
          vim.cmd("qa")
        end)

        return {
          type = "group",
          val = buttons,
          opts = { position = "center" },
        }
      end

      return {
        layout = {
          { type = "padding", val = 1 },
          make_header_liens(),
          { type = "padding", val = 1 },
          {
            type = "group",
            val = make_recent_buttons,
          },
          { type = "padding", val = 1 },
          make_toolbar_buttons(),
          { type = "padding", val = 1 },
          {
            type = "text",
            val = make_fortune_text,
            opts = {
              hl = "AlphaQuote",
              position = "center",
            },
          },
        },
        opts = {
          margin = 5,
          redraw_on_resize = true,
          setup = function()
            vim.api.nvim_create_autocmd("User", {
              pattern = "LazyVimStarted",
              once = true,
              callback = function()
                vim.schedule(function()
                  require("alpha").redraw()
                end)
              end,
            })
            redraw_alpha_autocmd = vim.api.nvim_create_autocmd("DirChanged", {
              pattern = "*",
              callback = function()
                vim.schedule(function()
                  require("alpha").redraw()
                end)
              end,
            })
          end,
        },
      }
    end,
  },
}
