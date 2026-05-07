{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_mode = {
      "mode",
      icons_enabled = false,
      icon = { " ", align = "left" },
      separator = { left = "", right = "" },
      padding = 1,
      fmt = function()
        local mode_map = {
          n = "(ᴗ_ ᴗ。)",
          nt = "(ᴗ_ ᴗ。)",
          i = "(•̀ - •́ )",
          R = "( •̯́ ₃ •̯̀)",
          v = "(⊙ _ ⊙ )",
          V = "(⊙ _ ⊙ )",
          no = "Σ(°△°ꪱꪱꪱ)",
          ["\22"] = "(⊙ _ ⊙ )",
          t = "(⌐■_■)",
          ["!"] = "Σ(°△°ꪱꪱꪱ)",
          c = "Σ(°△°ꪱꪱꪱ)",
          s = "SUB",
        }
        return mode_map[vim.api.nvim_get_mode().mode]
          or vim.api.nvim_get_mode().mode
      end,
    }
  '';
}
