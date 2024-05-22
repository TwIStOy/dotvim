vim.loader.enable()
local dotpath = os.getenv("HOME") .. "/.dotvim"
vim.opt.rtp:prepend(dotpath)
require("dotvim.bootstrap").setup()
