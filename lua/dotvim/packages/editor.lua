---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages.editor",
  deps = {
    "dora.packages.editor",
  },
  plugins = {
    {
      "vim-illuminate",
      opts = function(_, opts)
        ---@type string[]
        local denylist = vim.deepcopy(opts.filetypes_denylist)
        vim.list_extend(denylist, {
          "noice",
          "neo-tree",
          "startify",
          "NvimTree",
          "packer",
          "alpha",
          "nuipopup",
          "toggleterm",
          "noice",
          "crates.nvim",
          "lazy",
          "Trouble",
          "rightclickpopup",
          "TelescopePrompt",
          "Glance",
          "DressingInput",
          "lspinfo",
          "nofile",
          "mason",
          "Outline",
          "aerial",
          "flutterToolsOutline",
          "neo-tree",
          "neo-tree-popup",
          "fzf",
        })
        local ret = {}
        for _, ft in ipairs(denylist) do
          ret[ft] = true
        end
        opts.filetypes_denylist = vim.tbl_keys(ret)
      end,
    },
  },
}
