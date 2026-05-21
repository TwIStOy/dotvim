_: {
  plugins.gitsigns = {
    enable = true;

    lazyLoad.settings.event = [ "BufReadPre" "BufNewFile" ];

    settings = {
      signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "";
        topdelete.text = "";
        changedelete.text = "▎";
        untracked.text = "▎";
      };
      signcolumn = true;
      numhl = false;
      linehl = false;
      word_diff = false;
      watch_gitdir = {
        interval = 1000;
        follow_files = true;
      };
      update_debounce = 100;
    };
  };
}
