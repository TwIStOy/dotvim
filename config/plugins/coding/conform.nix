_: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format = {
        timeout_ms = 3000;
        async = false;
        quiet = false;
      };
    };
  };

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>fc";
      action.__raw = ''
        function()
          require("conform").format {
            async = true,
            lsp_fallback = true,
          }
        end
      '';
      options.desc = "format-file";
    }
  ];
}
