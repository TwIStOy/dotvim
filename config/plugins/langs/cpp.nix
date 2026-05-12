_: {
  plugins.clangd-extensions = {
    enable = true;
    lazyLoad.settings.ft = ["c" "cpp"];
    settings = {
      memory_usage = {border = "rounded";};
      symbol_info = {border = "rounded";};
    };
  };

  autoCmd = [
    {
      event = "LspAttach";
      callback.__raw = ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "clangd" then
            vim.keymap.set("n", "<leader>fa", function()
              vim.cmd("ClangdSwitchSourceHeader")
            end, {desc = "switch-source-header", buffer = args.buf})
          end
        end
      '';
    }
  ];
}
