return {
  -- big J
  {
    "osyo-manga/vim-jplus",
    allow_in_vscode = true,
    event = "BufReadPost",
    keys = { { "J", "<Plug>(jplus)", mode = { "n", "v" }, noremap = false } },
  },
}
