local Const = require("ht.core.const")

local function setup()
  vim.opt.title = false
  vim.opt.ttyfast = true

  vim.opt.termguicolors = true

  vim.o.updatetime = 100
  vim.o.redrawtime = 1500
  vim.o.timeout = true
  vim.o.ttimeout = true
  vim.o.timeoutlen = 500
  vim.o.ttimeoutlen = 10

  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  vim.o.sessionoptions =
    "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  -- no bells
  vim.cmd([[set noerrorbells novisualbell t_vb=]])

  -- numbers
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "yes"
  vim.opt.cursorline = true

  -- cursor settings
  vim.opt.guicursor =
    "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n-v-c:blinkon500-blinkoff500,a:Cursor/lCursor"
  vim.opt.termsync = true

  -- mouse mode
  vim.opt.mouse = "a"
  vim.opt.mousemoveevent = true

  -- statusline
  vim.opt.laststatus = 3

  -- edit settings
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true

  -- default tab width: 2
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2

  vim.opt.showmode = false
  vim.opt.cmdheight = 1

  vim.opt.exrc = true

  vim.opt.wrap = true

  vim.opt.fillchars = "eob: "

  vim.opt.scrolloff = 5

  vim.opt.timeoutlen = 300

  vim.opt.hidden = true

  -- jump options
  vim.opt.jumpoptions = "stack"

  -- clipboard
  if Const.os.is_linux then
    if Const.os.in_orb then
      local copy_settings = {}
      copy_settings["+"] = { "pbcopy" }
      copy_settings["*"] = { "pbcopy" }
      local paste_settings = {}
      paste_settings["+"] = { "pbpaste" }
      paste_settings["*"] = { "pbpaste" }
      vim.g.clipboard = {
        name = "pbcopy/pbpaste",
        copy = copy_settings,
        paste = paste_settings,
        cache_enabled = 1,
      }
    else
      local copy_settings = {}
      copy_settings["+"] = { "nc", "localhost", "2224", "-w0" }
      copy_settings["*"] = { "nc", "localhost", "2224", "-w0" }
      local paste_settings = {}
      paste_settings["+"] = { "nc", "localhost", "2225", "-w1" }
      paste_settings["*"] = { "nc", "localhost", "2225", "-w1" }
      vim.g.clipboard = {
        name = "ssh-remote-clip",
        copy = copy_settings,
        paste = paste_settings,
        cache_enabled = 1,
      }
    end
  end

  -- allow misspellings
  vim.cmd.cnoreabbrev("qw", "wq")
  vim.cmd.cnoreabbrev("W", "w")
  vim.cmd.cnoreabbrev("Wq", "wq")
  vim.cmd.cnoreabbrev("WQ", "wq")
end

return {
  setup = setup,
}
