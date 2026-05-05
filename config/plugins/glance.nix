_: {
  plugins.glance = {
    enable = true;
    lazyLoad.settings = {
      cmd = "Glance";
      keys = [
        {
          __unkeyed-1 = "gd";
          __unkeyed-2.__raw = ''
            function()
              require("glance").open("definitions")
            end
          '';
          desc = "goto-definitions";
          mode = "n";
        }
        {
          __unkeyed-1 = "gt";
          __unkeyed-2.__raw = ''
            function()
              require("glance").open("type_definitions")
            end
          '';
          desc = "goto-type-definitions";
          mode = "n";
        }
        {
          __unkeyed-1 = "gi";
          __unkeyed-2.__raw = ''
            function()
              require("glance").open("implementations")
            end
          '';
          desc = "goto-implementations";
          mode = "n";
        }
        {
          __unkeyed-1 = "gr";
          __unkeyed-2.__raw = ''
            function()
              require("glance").open("references")
            end
          '';
          desc = "goto-references";
          mode = "n";
        }
      ];
    };
    settings = {
      detached.__raw = ''
        function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end
      '';
      preview_win_opts = {
        cursorline = true;
        number = true;
        wrap = false;
      };
      border = {
        disable = true;
        top_char = "―";
        bottom_char = "―";
      };
      theme.enable = true;
      list.width = 0.2;
      mappings = {
        list = {
          "j" = {
            __raw = "require('glance').actions.next";
          };
          "k" = {
            __raw = "require('glance').actions.previous";
          };
          "<Down>" = false;
          "<Up>" = false;
          "<Tab>" = {
            __raw = "require('glance').actions.next_location";
          };
          "<S-Tab>" = {
            __raw = "require('glance').actions.previous_location";
          };
          "<C-u>" = {
            __raw = "require('glance').actions.preview_scroll_win(5)";
          };
          "<C-d>" = {
            __raw = "require('glance').actions.preview_scroll_win(-5)";
          };
          "v" = false;
          "s" = false;
          "t" = false;
          "<CR>" = {
            __raw = "require('glance').actions.jump";
          };
          "o" = false;
          "<leader>l" = false;
          "q" = {
            __raw = "require('glance').actions.close";
          };
          "Q" = {
            __raw = "require('glance').actions.close";
          };
          "<Esc>" = {
            __raw = "require('glance').actions.close";
          };
        };
        preview = {
          "Q" = {
            __raw = "require('glance').actions.close";
          };
          "<Tab>" = false;
          "<S-Tab>" = false;
          "<leader>l" = false;
        };
      };
      folds = {
        fold_closed = "󰅂";
        fold_open = "󰅀";
        folded = false;
      };
      indent_lines.enable = false;
      winbar.enable = true;
      hooks = {
        before_open.__raw = ''
          function(results, open, jump, method)
            if method == "references" or method == "implementations" then
              open(results)
            elseif #results == 1 then
              jump(results[1])
            else
              open(results)
            end
          end
        '';
      };
    };
  };
}
