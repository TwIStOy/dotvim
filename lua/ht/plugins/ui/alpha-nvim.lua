local Const = require("ht.core.const")
local UtilsProject = require("ht.utils.project")
local UtilsTbl = require("ht.utils.table")

local dependencies = {
  "nvim-tree/nvim-web-devicons",
  "nvim-lua/plenary.nvim",
}
if Const.is_gui then
  dependencies[#dependencies + 1] = "TwIStOy/project.nvim"
end

local M = {
  "goolord/alpha-nvim",
  cond = function()
    return vim.fn.argc() == 0 and vim.o.lines >= 36 and vim.o.columns >= 80
  end,
  lazy = false,
  dependencies = dependencies,
}

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
  ignore = function(p, ext)
    return (string.find(p, "COMMIT_EDITMSG"))
      or (vim.tbl_contains(default_mru_ignore, ext))
  end,
}

local function get_extension(fn)
  local match = fn:match("^.+(%..+)$")
  local ext = ""
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local function button(sc, txt, callback, opts)
  local on_press
  if type(callback) == "string" then
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(
        callback .. "<Ignore>",
        true,
        false,
        true
      )
      vim.api.nvim_feedkeys(key, "t", false)
    end
  else
    on_press = callback
  end

  opts = opts or {}
  opts = vim.tbl_extend("force", {
    position = "center",
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
    keymap = {
      "n",
      sc,
      "",
      { noremap = true, silent = true, nowait = true, callback = on_press },
    },
  }, opts)
  return { type = "button", val = txt, on_press = on_press, opts = opts }
end

local function file_button(fn, sc, short_fn)
  local nvim_web_devicons = require("nvim-web-devicons")
  local dashboard = require("alpha.themes.dashboard")

  local function icon(filename)
    local ext = get_extension(filename)
    return nvim_web_devicons.get_icon(filename, ext, { default = true })
  end

  short_fn = short_fn or fn
  local ico_txt
  local fb_hl = {}

  local ico, hl = icon(fn)
  local hl_option_type = type(nvim_web_devicons.highlight)
  if hl_option_type == "boolean" then
    if hl and nvim_web_devicons.highlight then
      table.insert(fb_hl, { hl, 0, 1 })
    end
  end
  if hl_option_type == "string" then
    table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
  end
  ico_txt = ico .. "  "

  local file_button_el =
    dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
  local fn_start = short_fn:match(".*/")
  if fn_start ~= nil then
    table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
  end
  file_button_el.opts.hl = fb_hl
  return file_button_el
end

local function project_button(sc, project_path)
  local nvim_web_devicons = require("nvim-web-devicons")

  local kind = UtilsProject.get_project_kind(project_path)
  local icon_txt
  if kind ~= nil then
    icon_txt = nvim_web_devicons.get_icon_by_filetype(kind, { default = true })
  else
    icon_txt = ""
  end
  icon_txt = icon_txt .. "  "

  return button(
    sc,
    icon_txt .. vim.fn.fnamemodify(project_path, ":~"),
    "<cmd>cd " .. project_path .. " <CR>"
  )
end

local function fortune()
  local stats = require("lazy").stats()
  return string.format(
    "󰂖 %d plugins loaded in %dms",
    stats.count,
    stats.startuptime
  )
end

local function build_buttons(arr)
  local globals = require("ht.core.globals")

  local buttons = {
    {
      type = "text",
      val = "Quick Actions",
      opts = { hl = "SpecialComment", position = "center" },
    },
    { type = "padding", val = 1 },
  }

  buttons[#buttons + 1] =
    button("e", "󱪝  " .. arr .. " New File", ":ene <BAR> startinsert <CR>")

  buttons[#buttons + 1] = button("c", "  " .. arr .. " Settings", function()
    local builtin = require("telescope.builtin")
    builtin.find_files { cwd = "$HOME/.dotvim" }
  end)

  buttons[#buttons + 1] = button(
    "f",
    "󰺮  " .. arr .. " Search Obsidian",
    function()
      vim.cmd("ObsidianSearch")
    end
  )

  buttons[#buttons + 1] = button(
    "t",
    "󰃶  " .. arr .. " Obsidian Today",
    function()
      vim.cmd("ObsidianToday")
    end
  )

  buttons[#buttons + 1] =
    button("u", "󰚰  " .. arr .. " Update Plugins", ":Lazy update<CR>")

  if Const.is_gui then
    buttons[#buttons + 1] =
      button("p", "  " .. arr .. " Projects", ":PickRecentProject<CR>")
  end

  buttons[#buttons + 1] = button("q", "󰗼  " .. arr .. " Quit", ":qa<CR>")

  return buttons
end

local function build_recent_files_section()
  local path = require("plenary.path")

  local function mru(start, cwd, items_number, opts)
    opts = opts or mru_opts
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
      local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
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

      local file_button_el = file_button(fn, " " .. shortcut, short_fn)
      tbl[i] = file_button_el
    end
    return { type = "group", val = tbl, opts = {} }
  end

  return {
    type = "group",
    val = {
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
    },
  }
end

local function build_recent_projects_section()
  local function _build_buttons()
    local project_nvim = require("project_nvim")
    local recent_projects = project_nvim.get_recent_projects()
    UtilsTbl.list_reverse(recent_projects)

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
      buttons[#buttons + 1] = project_button(" " .. shortcut, project_path)
    end

    -- return { type = "group", val = buttons, opts = {} }
    return buttons
  end

  local ret = {
    type = "group",
    val = {
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
    },
  }
  return ret
end

local function build_recent_section()
  local cwd = vim.fn.getcwd()
  if cwd == "/" then
    return build_recent_projects_section()
  else
    return build_recent_files_section()
  end
end

M.config = function() -- code to run after plugin loaded
  local alpha = require("alpha")

  local header_text_winnie = {
    [[                           $$$$F**+           .oW$$$eu]],
    [[                           ..ueeeWeeo..      e$$$$$$$$$]],
    [[                       .eW$$$$$$$$$$$$$$$b- d$$$$$$$$$$W]],
    [[           ,,,,,,,uee$$$$$$$$$$$$$$$$$$$$$ H$$$$$$$$$$$~]],
    [[        :eoC$$$$$$$$$$$C""?$$$$$$$$$$$$$$$ T$$$$$$$$$$"]],
    [[         $$$*$$$$$$$$$$$$$e "$$$$$$$$$$$$$$i$$$$$$$$F"]],
    [[         ?f"!?$$$$$$$$$$$$$$ud$$$$$$$$$$$$$$$$$$$$*Co]],
    [[         $   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]],
    [[ !!!!m.*eeeW$$$$$$$$$$$f?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$U]],
    [[ !!!!!! !$$$$$$$$$$$$$$  T$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]],
    [[  *!!*.o$$$$$$$$$$$$$$$e,d$$$$$$$$$$$$$$$$$$$$$$$$$$$$$:]],
    [[ "eee$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$C]],
    [[b ?$$$$$$$$$$$$$$**$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$!]],
    [[Tb "$$$$$$$$$$$$$$*uL"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$']],
    [[ $$o."?$$$$$$$$F" u$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$]],
    [[  $$$$en ```    .e$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$']],
    [[   $$$B*  =*"?.e$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$F]],
    [[    $$$W"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"]],
    [[     "$$$o#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"]],
    [[       ?$$$W$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"]],
  }

  --  local header_text = {
  --    "                                                     ",
  --    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  --    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  --    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  --    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  --    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  --    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  --    "                                                     ",
  --  }

  local function header_with_color()
    local lines = {}
    for i, line_chars in pairs(header_text_winnie) do
      local hi = "StartLogo" .. i
      local line = {
        type = "text",
        val = line_chars,
        opts = { hl = hi, shrink_margin = false, position = "center" },
      }
      table.insert(lines, line)
    end
    table.insert(lines, {
      type = "text",
      val = "Last updated: " .. require("ht.version").last_updated_time,
      opts = { hl = "SpecialComment", position = "center" },
    })

    local output = {
      type = "group",
      val = lines,
      opts = { position = "center" },
    }

    return output
  end

  -- local arr = ICON("e602")
  local arr = ""
  local buttons = {
    type = "group",
    val = build_buttons(arr),
    position = "center",
  }

  local opts = {
    layout = {
      { type = "padding", val = 1 },
      header_with_color(),
      { type = "padding", val = 1 },
      build_recent_section(),
      { type = "padding", val = 1 },
      buttons,
      { type = "padding", val = 1 },
      {
        type = "text",
        val = fortune,
        opts = { hl = "AlphaQuote", position = "center" },
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
            require("alpha").redraw()
          end,
        })
      end,
    },
  }

  alpha.setup(opts)
end

return M
