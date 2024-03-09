vim.loader.enable()
local dotpath = "/Users/hawtian/.dotvim"
vim.opt.rtp:prepend(dotpath)
require("dotvim").setup()
