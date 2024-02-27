---@type dora.core.plugin.PluginOptions[]
return {
  {
    "altermo/ultimate-autopair.nvim",
    gui = "all",
    event = {
      "InertEnter",
      "CmdlineEnter",
    },
    opts = {
      close = {
        map = "<C-0>",
        cmap = "<C-0>",
      },
      tabout = {
        hopout = true,
      },
      fastwarp = {
        enable = true,
        map = "<C-=>",
        rmap = "<C-->",
        cmap = "<C-=>",
        crmap = "<C-->",
        enable_normal = true,
        enable_reverse = true,
        hopout = false,
        multiline = true,
        nocursormove = true,
        no_nothing_if_fail = false,
      },
      config_internal_pairs = {
        {
          "'",
          "'",
          suround = true,
          cond = function(fn)
            return not fn.in_lisp() or fn.in_string()
          end,
          alpha = true,
          nft = { "tex", "rust" },
          multiline = false,
        },
      },
    },
  },
  {
    "kylechui/nvim-surround",
    gui = "all",
    version = "*",
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    gui = "all",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      context_commentstring = {
        enable = true,
      },
    },
    config = function(_, opts)
      vim.g.skip_ts_context_commentstring_module = true
      require("ts_context_commentstring").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    gui = "all",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "gcc", desc = "toggle-line-comment" },
      { "gcc", mode = "x", desc = "toggle-line-comment" },
      { "gbc", desc = "toggle-block-comment" },
      { "gbc", mode = "x", desc = "toggle-block-comment" },
    },
    opts = {
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gcc", block = "gbc" },
      mappings = { basic = true, extra = false },
      pre_hook = function()
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    },
    config = true,
  },
}
