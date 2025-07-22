local avatar_path = os.getenv("HOME") .. "/.dotvim/resource/avatar.png"

---@type dotvim.core.plugin.PluginOption
return {
  "Kurama622/profile.nvim",
  dependencies = { "3rd/image.nvim" },
  cmd = { "Profile" },
  config = function()
    local comp = require("profile.components")
    require("profile").setup {
      avatar_path = avatar_path,
      user = "TwIStOy",
      git_contributions = {
        start_week = 1,
        end_week = 53,
        empty_char = " ",
        full_char = { "", "󰧞", "", "", "" },
        fake_contributions = nil,
      },
      hide = {
        statusline = true,
        tabline = true,
      },
      disable_move = true,
      format = function()
        comp:avatar()


        comp:separator_render()

        comp:git_contributions_render("ProfileGreen")
      end,
    }
  end,
}
