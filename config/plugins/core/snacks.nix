_: {
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      lazygit.configure = true;
      picker = {
        enabled = true;
        win.input.keys = {
          "<Esc>" = {
            __raw = ''
              { "close", mode = { "n", "i" } }
            '';
          };
        };
        formatters.file.filename_first = true;
        previewers.file.max_size.__raw = ''
          1024 * 1024
        '';
      };
      dashboard = {
        enabled.__raw = ''
          vim.fn.argc() == 0 and vim.o.lines >= 36 and vim.o.columns >= 80
        '';
        preset = {
          keys = [
            {
              icon = "";
              key = "f";
              desc = "Find File";
              action.__raw = ''
                function()
                  require("snacks").picker.files()
                end
              '';
            }
            {
              icon = "";
              key = "e";
              desc = "New File";
              action = ":ene | startinsert";
            }
            {
              icon = "";
              key = "r";
              desc = "Recent Files";
              action.__raw = ''
                function()
                  require("snacks").picker.recent()
                end
              '';
            }
            {
              icon = "";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };
        sections = [
          {
            icon = "";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
            limit = 5;
            cwd = true;
          }
          {
            icon = "󰊢";
            title = "Projects";
            section = "projects";
            indent = 2;
            padding = 1;
            limit = 5;
          }
          { section = "keys"; gap = 1; padding = 1; }
        ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>g";
      action.__raw = ''
        function()
          require("snacks").lazygit.open()
        end
      '';
      options.desc = "open-lazygit";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = ''
        function()
          require("snacks").picker.files({ cwd = vim.b._dotvim_project_cwd })
        end
      '';
      options.desc = "edit-project-files";
    }
    {
      mode = "n";
      key = "g/";
      action.__raw = ''
        function()
          require("snacks").picker.grep({ cwd = vim.b._dotvim_project_cwd })
        end
      '';
      options.desc = "live-grep";
    }
    {
      mode = "n";
      key = "<leader>lg";
      action.__raw = ''
        function()
          require("snacks").picker.grep({ cwd = vim.b._dotvim_project_cwd })
        end
      '';
      options.desc = "live-grep";
    }
    {
      mode = "n";
      key = "<F4>";
      action.__raw = ''
        function()
          require("snacks").picker.buffers()
        end
      '';
      options.desc = "all-buffers";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = ''
        function() require("snacks").picker.lsp_symbols() end
      '';
      options.desc = "document-symbols";
    }
    {
      mode = "n";
      key = "<leader>sw";
      action.__raw = ''
        function() require("snacks").picker.lsp_workspace_symbols() end
      '';
      options.desc = "workspace-symbols";
    }
    {
      mode = "n";
      key = "<leader>sW";
      action.__raw = ''
        function()
          require("snacks").picker.lsp_workspace_symbols({ filter = { cwd = vim.fn.expand("<cword>") } })
        end
      '';
      options.desc = "workspace-symbols-cword";
    }
  ];
}
