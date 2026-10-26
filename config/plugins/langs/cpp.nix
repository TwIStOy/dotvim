{pkgs, ...}: {
  # Pick the C++ server before startup. Not switchable at runtime:
  # "clangd" or "clice".
  globals.dotvim_cpp_lsp = "clangd";

  extraPlugins = [pkgs.clice.nvim];

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
          if not client then
            return
          end
          local cmd = nil
          if client.name == "clangd" then
            cmd = "ClangdSwitchSourceHeader"
          elseif client.name == "clice" then
            cmd = "LspCliceSwitchSourceHeader"
          end
          if cmd then
            vim.keymap.set("n", "<leader>fa", function()
              vim.cmd(cmd)
            end, { desc = "switch-source-header", buffer = args.buf })
          end
        end
      '';
    }
  ];

  extraConfigLuaPost = ''
    local servers = {
      clang = "clangd",
      clangd = "clangd",
      clice = "clice",
    }
    local choice = vim.g.dotvim_cpp_lsp
    local server = servers[choice]
    if server == nil then
      vim.notify(
        "dotvim_cpp_lsp: expected clangd or clice, got "
          .. vim.inspect(choice),
        vim.log.levels.ERROR
      )
      server = "clangd"
    end
    vim.lsp.enable(server)
  '';
}
