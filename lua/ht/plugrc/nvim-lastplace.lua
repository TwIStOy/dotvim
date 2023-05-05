return {
  "ethanholz/nvim-lastplace",
  event = "BufReadPre",
  opts = {
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = false,
  },
}
