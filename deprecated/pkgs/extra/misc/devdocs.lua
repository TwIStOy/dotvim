---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.devdocs",
  deps = {
    "editor",
    "treesitter",
  },
  plugins = {
    {
      "luckasRanarison/nvim-devdocs",
      dependencies = {
        "plenary.nvim",
        "telescope.nvim",
        "nvim-treesitter",
      },
      opts = {
        ensure_installed = {
          "html",
          "cpp",
          "rust",
        },
        previewer_cmd = "glow",
        cmd_args = { "-s", "auto", "-w", "80" },
        picker_cmd = true,
        picker_cmd_args = { "-s", "auto", "-w", "80" },
      },
      cmd = {
        "DevdocsFetch",
        "DevdocsInstall",
        "DevdocsUninstall",
        "DevdocsOpen",
        "DevdocsOpenFloat",
        "DevdocsOpenCurrent",
        "DevdocsOpenCurrentFloat",
        "DevdocsToggle",
        "DevdocsUpdate",
        "DevdocsUpdateAll",
      },
    },
  },
}
