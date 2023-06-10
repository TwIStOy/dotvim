local event = require("ht.core.event")

-- Disable arrows
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

vim.opt.title = false
vim.opt.ttyfast = true

-- vim.opt.lazyredraw = true
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

-- no bells
vim.cmd([[set noerrorbells novisualbell t_vb=]])

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.relative_number_blacklist = {
  "startify",
  "NvimTree",
  "packer",
  "alpha",
  "nuipopup",
  "toggleterm",
  "noice",
  "crates.nvim",
  "lazy",
  "Trouble",
  "rightclickpopup",
  "TelescopePrompt",
  "Glance",
}

event.on("TermEnter", { pattern = "*", command = "setlocal nonu nornu" })
event.on({ "BufEnter", "FocusGained", "WinEnter" }, {
  pattern = "*",
  command = "if index(g:relative_number_blacklist, &ft) == -1 | set nu rnu | endif",
})
event.on({ "BufLeave", "FocusLost", "WinLeave" }, {
  pattern = "*",
  command = "if index(g:relative_number_blacklist, &ft) == -1 | set nu nornu | endif",
})
vim.opt.signcolumn = "yes"
event.on({ "BufEnter", "FocusGained", "WinEnter" }, {
  pattern = "*",
  command = "if index(g:relative_number_blacklist, &ft) == -1 | set signcolumn=yes | endif",
})

vim.opt.cursorline = true
vim.g.cursorline_blacklist = { "alpha", "noice" }
event.on({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "if index(g:cursorline_blacklist, &ft) == -1 | set cursorline | endif",
})
event.on(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline" }
)

-- cursor settings
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/lCursor"

-- mouse mode
vim.opt.mouse = "a"

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

-- move quickfix windows to botright automatically
event.on("FileType", { pattern = "qf", command = "wincmd J" })

-- default colorcolumn: 80
vim.opt.colorcolumn = "80"

vim.opt.scrolloff = 5

vim.opt.timeoutlen = 300

vim.opt.hidden = true

-- jump options
vim.opt.jumpoptions = "stack"

-- highlight on yank
event.on("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- setup clipboard vis ssh, other settings: [[~/Dropbox/vimwiki/Remote Clipboard.wiki]]
if vim.fn.has("linux") == 1 then
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

event.on("BufEnter,WinClosed", {
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

vim.keymap.set(
  { "n", "i", "v" },
  "<C-s>",
  "<cmd>update<CR>",
  { desc = true, silent = true }
)

NMAP(";;", function()
  require("ht.core.right-click").show()
end, "show-menu")

NMAP("<M-n>", "<cmd>nohl<CR>", "nohl")

NMAP("<leader>q", "<cmd>q<CR>", "quit")
NMAP("<leader>Q", "<cmd>confirm qall<CR>", "quit-all")

NMAP("tq", function()
  require("ht.core.window").toggle_quickfix()
end, "toggle-quickfix")

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
  vim.o.guifont = "Iosevka:h22"

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_profiler = false
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_no_idle = true
  vim.g.neovide_input_macos_alt_is_meta = true

  vim.g.neovide_input_use_logo = true

  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end
