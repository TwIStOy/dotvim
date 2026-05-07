_: {
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping.__raw = ''"<C-t>"'';
      insert_mappings = false;
      hide_numbers = true;
      direction = "float";
      start_in_insert = true;
      shell.__raw = "vim.o.shell";
      close_on_exit = true;
      float_opts.border = "rounded";
    };
  };

  globals.toggleterm_terminal_mapping = "<C-t>";

  keymaps = [
    {
      mode = "n";
      key = "<C-t>";
      action = "<cmd>ToggleTerm<CR>";
      options.desc = "open-term";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = ''
        function()
          local exec = vim.fn.executable("yazi")
          if exec ~= 1 then
            vim.notify(
              "Command [yazi] not found!",
              vim.log.levels.ERROR,
              { title = "toggleterm.nvim" }
            )
            return
          end
          require("toggleterm.terminal").Terminal
            :new({
              cmd = "yazi",
              direction = "float",
              close_on_exit = true,
              float_opts = { border = "none" },
              start_in_insert = true,
              hidden = true,
            })
            :open()
        end
      '';
      options.desc = "open-yazi";
    }
  ];
}
