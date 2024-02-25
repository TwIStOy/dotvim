---@type dora.lib.PluginOptions
return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function(_, opts)
    opts = opts or {}
    return vim.tbl_deep_extend("force", opts, {
      code_action = {
        num_shortcut = true,
        show_server_name = true,
        extend_gitsigns = false,
        keys = { quit = { "q", "<Esc>" }, exec = "<CR>" },
      },
      lightbulb = { enable = false },
      symbol_in_winbar = { enable = false },
      ui = {
        border = "none",
      },
    })
  end,
}
