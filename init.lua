vim.opt.rtp:prepend("~/Projects/dora.nvim")

---@class dora
local dora = require("dora")

dora.setup {
  plugins = {
    { import = "_builtin" },
    { import = "utils" },
    { import = "theme" },
    { import = "coding.luasnip" },
    { import = "coding.nvim-cmp" },
    { import = "coding.conform" },
    { import = "coding._others" },
  },
}
