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
    {
      "project.nvim",
      event = {
        "BufReadPost",
        "BufNewFile",
      },
      opts = function(_, opts)
        ---@type dora.lib
        local lib = require("dora.lib")
        ---@type dotvim.utils
        local Utils = require("dotvim.utils")
        opts.manual_mode = true
        opts.patterns = Utils.tbl.merge_array(opts.patterns, {
          "BLADE_ROOT",
          "blast.json",
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "Makefile",
          "package.json",
          "HomePage.md", -- for my personal obsidian notes
        })
        opts.exclude_dirs = Utils.tbl.merge_array(opts.exclude_dirs, {
          "~/.cargo/*",
        })
        opts.silent_chdir = false
      end,
      config = function(_, opts)
        opts = opts or {}
        require("project_nvim").setup(opts)
      end,
    },
    {
      "Bekaboo/dropbar.nvim",
      dependencies = {
        "telescope-fzf-native.nvim",
      },
    },
  },
}
