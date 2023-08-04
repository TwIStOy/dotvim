local Const = require("ht.core.const")

-- Disable arrows
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

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

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("wincmd =")
    vim.cmd("tabdo wincmd =")
  end,
})

-- cursor settings
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor"

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

-- move quickfix windows to botright automatically
vim.api.nvim_create_autocmd(
  "FileType",
  { pattern = "qf", command = "wincmd J" }
)

vim.opt.scrolloff = 5

vim.opt.timeoutlen = 300

vim.opt.hidden = true

-- jump options
vim.opt.jumpoptions = "stack"

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

vim.api.nvim_create_autocmd({ "BufEnter", "WinClosed" }, {
  pattern = "*",
  callback = function()
    require("ht.core.window").check_last_window()
  end,
})

NMAP("<leader>wv", "<cmd>wincmd v<CR>", "split-window-vertical")

NMAP("<leader>w-", "<cmd>wincmd s<CR>", "split-window-horizontal")

NMAP("<leader>w=", "<cmd>wincmd =<CR>", "balance-window")

NMAP("<leader>wr", "<cmd>wincmd r<CR>", "rotate-window-rightwards")

NMAP("<leader>wx", "<cmd>wincmd x<CR>", "exchange-window-with-next")

for i = 1, 9 do
  NMAP("<leader>" .. i, function()
    require("ht.core.window").goto_window(i)
  end, "goto-win-" .. i)
end

NMAP("<leader>fs", "<cmd>update<CR>", "update")
if require("ht.core.const").is_gui then
  vim.keymap.set(
    { "n", "i", "v" },
    "<Char-0xAA>",
    "<cmd>update<CR>",
    { silent = true }
  )
else
  vim.keymap.set(
    { "n", "i", "v" },
    "<D-s>",
    "<cmd>update<CR>",
    { silent = true }
  )
end

NMAP(";;", function()
  require("ht.core.right-click").show()
end, "show-menu")

NMAP("<M-n>", "<cmd>nohl<CR>", "nohl")

NMAP("<leader>q", "<cmd>q<CR>", "quit")
NMAP("<leader>Q", "<cmd>confirm qall<CR>", "quit-all")

NMAP("<C-p>", function()
  require("telescope").extensions.command_palette.command_palette {
    layout_strategy = "center",
    sorting_strategy = "ascending",
    layout_config = {
      anchor = "N",
      width = 0.5,
      prompt_position = "top",
      height = 0.5,
    },
    border = true,
    results_title = false,
    -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
end, "open-command-palette")

-- gui: neovide
if vim.g["fvim_loaded"] then
  vim.o.guifont = "Iosevka:h26"
end

-- gui: neovide
if vim.g["neovide"] then
  require("ht.conf.gui.neovide").setup()
end
