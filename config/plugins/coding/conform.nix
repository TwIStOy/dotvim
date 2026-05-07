{pkgs, lib, ...}: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format = {
        timeout_ms = 3000;
        async = false;
        quiet = false;
      };
      formatters_by_ft = {
        lua = ["stylua"];
        python = ["black"];
        go = ["goimports" "gofumpt"];
        sh = ["shfmt"];
        nix = ["alejandra"];
        cpp = ["clang_format"];
        c = ["clang_format"];
        rust = ["rustfmt"];
        typescript = ["prettier"];
        typescriptreact = ["prettier"];
        javascript = ["prettier"];
        javascriptreact = ["prettier"];
        markdown = ["prettier"];
      };
      formatters = {
        stylua.command = lib.getExe pkgs.stylua;
        black.command = lib.getExe pkgs.black;
        goimports.command = lib.getExe' pkgs.gotools "goimports";
        gofumpt.command = lib.getExe pkgs.gofumpt;
        shfmt.command = lib.getExe pkgs.shfmt;
        alejandra.command = lib.getExe pkgs.alejandra;
        clang_format.command = lib.getExe' pkgs.clang-tools "clang-format";
        rustfmt.command = lib.getExe pkgs.rustfmt;
        prettier.command = lib.getExe pkgs.prettier;
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
