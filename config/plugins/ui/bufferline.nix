{lib, ...}: {
  plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        '';
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            text_align = "left";
            separator = true;
          }
          {
            filetype = "NvimTree";
            text = "File Explorer";
            text_align = "left";
            separator = true;
          }
        ];
      };
      highlights = {
        buffer_selected.bold = true;
        indicator_selected = {
          fg.__raw = ''
            { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" }
          '';
          bg.__raw = ''
            { attribute = "bg", highlight = "Normal" }
          '';
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<M-,>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options.desc = "prev-buffer";
    }
    {
      mode = "n";
      key = "<M-.>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options.desc = "next-buffer";
    }
    {
      mode = "n";
      key = "<M-<>";
      action = "<cmd>BufferLineMovePrev<cr>";
      options.desc = "move-buffer-prev";
    }
    {
      mode = "n";
      key = "<M->>";
      action = "<cmd>BufferLineMoveNext<cr>";
      options.desc = "move-buffer-next";
    }
  ];
}
