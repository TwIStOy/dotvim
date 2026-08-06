_: {
  plugins.kulala = {
    enable = true;
    # kulala.nvim v5+ removed the `:Kulala` user command entirely (it is now a
    # pure Lua API + keymaps). Lazy-loading on a non-existent command would
    # install a stub that never resolves, so load on filetype only.
    lazyLoad.settings = {
      ft = [
        "http"
        "rest"
      ];
    };
  };
}
