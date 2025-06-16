local icon = require("dotvim.commons.icon")

-- Mode mapping with emotes
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

-- Component: Mode with emotes
local function create_component()
  return {
    "mode",
    icons_enabled = false,
    icon = {
      icon.get("VimLogo", 1),
      align = "left",
    },
    separator = { left = "", right = "" },
    padding = 1,
    fmt = function()
      return mode_map[vim.api.nvim_get_mode().mode]
        or vim.api.nvim_get_mode().mode
    end,
  }
end

return create_component
