local Const = require("ht.core.const")

return {
  {
    "keaising/im-select.nvim",
    enabled = false and Const.os.is_macos,
    config = function()
      require("im_select").setup {
        default_im_select = "com.apple.keylayout.ABC",
        async_switch_im = false,
        set_default_events = {
          "VimEnter",
          "FocusGained",
          "InsertLeave",
          "CmdlineLeave",
        },
        set_previous_events = { "InsertEnter" },
      }
    end,
  },
}
