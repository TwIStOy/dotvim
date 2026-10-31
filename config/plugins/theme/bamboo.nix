{pkgs, ...}: {
  # bamboo.nvim — warm green-toned scheme, three styles: "vulgaris"
  # (regular dark), "multiplex" (greener dark), "light".
  #
  # colors/bamboo.lua is a follow entry point: colorscheme() READS
  # 'background' (light -> light style; dark -> keeps the current dark
  # style) and never writes it from there, so Neovim's native reload on
  # 'background' change keeps working (same contract as catppuccin).
  # colors_name is always "bamboo"; the variant wrappers (bamboo-light,
  # bamboo-multiplex, bamboo-vulgaris) force their style once and hand
  # control back to "bamboo" for later background changes.
  #
  # No setup() here: colors/bamboo.lua calls require("bamboo").setup()
  # with defaults itself, and the user opted for default (opaque)
  # settings. Ships its own lualine theme; colors/*.lua clears
  # package.loaded for every "*bamboo*" module (including
  # lualine.themes.bamboo), so lualine re-resolves the palette on every
  # (re)load.
  extraPlugins = [pkgs.vimPlugins.bamboo-nvim];
}
