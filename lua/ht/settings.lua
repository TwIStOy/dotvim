local Const = require("ht.core.const")
if not Const.in_vscode then
  require("ht.conf.options").setup()
  require("ht.conf.keymaps").setup()
  require("ht.conf.event").setup()
end

-- gui: fvim
if vim.g["fvim_loaded"] then
  vim.o.guifont = "Iosevka:h26"
end

-- gui: neovide
if vim.g.neovide then
  require("ht.conf.gui.neovide").setup()
end
