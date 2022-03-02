module('ht.plugs.alpha', package.seeall)

function config()
  local alpha = require 'alpha'
  local dashboard = require 'alpha.themes.dashboard'

  local header_text = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
  }

  local function header_with_color()
    local lines = {}
    for i, line_chars in pairs(header_text) do
      local hi = "StartLogo" .. i
      local line = {
        type = "text",
        val = line_chars,
        opts = { hl = hi, shrink_margin = false, position = "center" },
      }
      table.insert(lines, line)
    end

    local output = { type = "group", val = lines,
                     opts = { position = "center" } }

    return output
  end

  local buttons = {
    type = 'group',
    val = {
      {
        type = 'text',
        val = 'Quick Actions',
        opts = { hl = "SpecialComment", position = "center" },
      },
      { type = 'padding', val = 1 },
      dashboard.button('e', "  > New File", ":ene <BAR> startinsert <CR>"),
      --[[
    dashboard.button("f", "  > Find file",
                     ":cd $HOME/Workspace | Telescope find_files<CR>"),
    --]]
      dashboard.button("s", "  > Settings",
                       ':cd $HOME/.dotvim | Telescope find_files<CR>'),
      dashboard.button('u', "  > Update Plugins", ":PackerSync<CR>"),
      dashboard.button('q', '  > Quit', ':qa<CR>'),
      -- dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    },
    position = 'center',
  }

  local opts = {
    layout = {
      { type = 'padding', val = 2 },
      header_with_color(),
      { type = 'padding', val = 2 },
      buttons,
    },

    opts = { margin = 5 },
  }

  alpha.setup(opts)
end

-- vim: et sw=2 ts=2

