return {
  {
    "zbirenbaum/neodim",
    lazy = true,
    event = "LspAttach",
    enabled = false,
    config = function()
      require("neodim").setup {
        alpha = 0.75,
        blend_color = "#000000",
        update_in_insert = { enable = false, delay = 100 },
        hide = { virtual_text = true, signs = false, underline = false },
      }
    end,
  },
}
