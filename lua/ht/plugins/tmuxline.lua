return {
  -- used for update tmux tabline
  Use {
    "edkolev/tmuxline.vim",
    lazy = { lazy = true, cmd = { "Tmuxline" } },
    functions = { FuncSpec("Update current tmux theme", "Tmuxline") },
  },
}
