---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.wakatime",
  plugins = {
    {
      "wakatime/vim-wakatime",
      event = "BufReadPost",
      opts = {},
    },
  },
}
