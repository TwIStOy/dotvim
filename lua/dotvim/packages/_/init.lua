---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages._",
  deps = {
    "dora.packages._builtin",
  },
  plugins = {
    {
      "catppuccin",
      opts = function(_, opts)
        opts.flavour = "frappe"
        opts.styles.comments = {}
        opts.styles.conditionals = {}
        opts.color_overrides = {
          frappe = {
            rosewater = "#F5B8AB",
            flamingo = "#F29D9D",
            pink = "#AD6FF7",
            mauve = "#FF8F40",
            red = "#E66767",
            maroon = "#EB788B",
            peach = "#FAB770",
            yellow = "#FACA64",
            green = "#70CF67",
            teal = "#4CD4BD",
            sky = "#61BDFF",
            sapphire = "#4BA8FA",
            blue = "#00BFFF",
            lavender = "#00BBCC",
            text = "#C1C9E6",
            subtext1 = "#A3AAC2",
            subtext0 = "#8E94AB",
            overlay2 = "#7D8296",
            overlay1 = "#676B80",
            overlay0 = "#464957",
            surface2 = "#3A3D4A",
            surface1 = "#2F313D",
            surface0 = "#1D1E29",
            base = "#0b0b12",
            mantle = "#11111a",
            crust = "#191926",
          },
          macchiato = {
            rosewater = "#cc7983",
            flamingo = "#bb5d60",
            pink = "#d54597",
            mauve = "#a65fd5",
            red = "#b7242f",
            maroon = "#db3e68",
            peach = "#e46f2a",
            yellow = "#bc8705",
            green = "#1a8e32",
            teal = "#00a390",
            sky = "#089ec0",
            sapphire = "#0ea0a0",
            blue = "#017bca",
            lavender = "#8584f7",
            text = "#444444",
            subtext1 = "#555555",
            subtext0 = "#666666",
            overlay2 = "#777777",
            overlay1 = "#888888",
            overlay0 = "#999999",
            surface2 = "#aaaaaa",
            surface1 = "#bbbbbb",
            surface0 = "#cccccc",
            base = "#ffffff",
            mantle = "#eeeeee",
            crust = "#dddddd",
          },
        }
      end,
    },
  },
  setup = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("c", "")
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("r", "")
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("o", "")
      end,
    })
    if vim.g.neovide then
      require("dotvim.packages._.neovide").setup()
    end
  end,
}
