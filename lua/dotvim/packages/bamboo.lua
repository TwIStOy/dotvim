---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages.bamboo",
  deps = {
    "dora.packages._builtin",
  },
  plugins = {
    {
      "ribru17/bamboo.nvim",
      lazy = false,
      enabled = false,
      priority = 1000,
      opts = {
        cmp_itemkind_reverse = false,
        code_style = {
          comments = { italic = true },
          conditionals = { italic = true },
          namespace = { italic = true },
        },
        highlights = {
          ["@lsp.typemod.variable.mutable.rust"] = { fmt = "underline" },
          ["@lsp.typemod.selfKeyword.mutable.rust"] = { fmt = "underline" },
          ["@variable.builtin"] = { fmt = "italic" },
        },
        lualine = {
          transparent = false,
        },
        diagnostics = {
          darker = false,
          undercurl = true,
          background = true,
        },
      },
    },
  },
}
