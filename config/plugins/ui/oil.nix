# oil.nvim — vinegar-style file explorer: a directory is just a buffer you edit,
# and `:w` applies the file operations. neo-tree stays for the tree view.
_: {
  plugins.oil = {
    enable = true;

    # Loaded at startup rather than lazily: oil takes over directory buffers
    # (`vim .`, `:e <dir>`) from the very beginning. With lazy loading it would
    # only start hijacking them after the first `<leader>-` / `<F2>` / `:Oil`.
    lazyLoad.settings.autoLoad = true;

    # `default_file_explorer` is left at the plugin default (true) on purpose:
    # oil is the directory-buffer explorer, neo-tree is reached via <leader>ft.
    settings.keymaps = {
      "<C-c>" = false;
      "<C-l>" = false;
      "y." = "actions.copy_entry_path";
      "q" = "actions.close";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<F2>";
      action.__raw = ''
        function()
          local oil = require("oil")
          if vim.bo.filetype == "oil" then
            oil.close()
          else
            oil.open()
          end
        end
      '';
      options.desc = "toggle-oil";
    }
    {
      mode = "n";
      key = "<leader>-";
      action.__raw = ''
        function()
          require("oil").open()
        end
      '';
      options.desc = "open-oil";
    }
  ];
}
