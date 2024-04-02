---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.codesnap",
  plugins = {
    {
      "mistricky/codesnap.nvim",
      build = "make",
      pname = "codesnap-nvim",
      cmd = {
        "CodeSnapSave",
        "CodeSnap",
      },
      opts = {
        save_path = "/tmp/codesnap.png",
        watermark = "",
        code_font_family = "Monolisa",
      },
    },
  },
}
