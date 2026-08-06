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

    settings = {
      # kulala merges this table over its defaults (tbl_extend "force"). Every
      # default entry that has NO `ft` would register GLOBALLY as <leader>R{...}
      # — disable those so nothing leaks outside http/rest buffers. Setting a
      # default name to `false` makes kulala skip it.
      global_keymaps = {
        "Open scratchpad" = false;
        "Open kulala" = false;
        "Send request" = false; # default <leader>Rs (global)
        "Send request <cr>" = false; # default <CR> (ft) — redefined explicitly below
        "Send all requests" = false; # default <leader>Ra (global)
        "Replay the last request" = false; # default <leader>Rr (global)

        # Buffer-scoped send/replay. kulala registers any entry with an `ft`
        # field as a buffer-local keymap (via FileType autocmd), so these only
        # live in http/rest buffers. `prefix = false` keeps the lhs as-is
        # (otherwise kulala prepends global_keymaps_prefix, default <leader>R).
        "Kulala send" = {
          __unkeyed-1 = "<CR>";
          __unkeyed-2.__raw = "function() require('kulala').run() end";
          mode = [
            "n"
            "v"
          ];
          ft = [
            "http"
            "rest"
          ];
          prefix = false;
        };
        "Kulala send all" = {
          __unkeyed-1 = "<leader>Ra";
          __unkeyed-2.__raw = "function() require('kulala').run_all() end";
          mode = [
            "n"
            "v"
          ];
          ft = [
            "http"
            "rest"
          ];
          prefix = false;
        };
        "Kulala replay" = {
          __unkeyed-1 = "<leader>Rr";
          __unkeyed-2.__raw = "function() require('kulala').replay() end";
          ft = [
            "http"
            "rest"
          ];
          prefix = false;
        };
      };
    };
  };
}
