{ lib, ... }:
let
  lu = lib.nixvim.utils.listToUnkeyedAttrs;
in
{
  plugins.blink-cmp = {
    enable = true;
    autoLoad = true;
    settings = {
      keymap = {
        preset = "none";
        "<CR>" = [ "accept" "fallback" ];
        "<C-p>" = [ "select_prev" "fallback" ];
        "<C-n>" = [ "select_next" "fallback" ];
        "<C-k>" = [ "select_prev" "fallback" ];
        "<C-j>" = [ "select_next" "fallback" ];
        "<C-u>" = [ "scroll_documentation_up" "fallback" ];
        "<C-d>" = [ "scroll_documentation_down" "fallback" ];
      };
      cmdline.enabled = false;
      sources.default = [ "lsp" "buffer" "snippets" ];
      snippets = {
        expand.__raw = ''
          function(snippet)
            require("luasnip").lsp_expand(snippet)
          end
        '';
        active.__raw = ''
          function(filter)
            if filter and filter.direction then
              return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
          end
        '';
        jump.__raw = ''
          function(direction)
            require("luasnip").jump(direction)
          end
        '';
      };
      completion = {
        keyword.range = "full";
        list.selection.preselect = false;
        menu = {
          draw = {
            gap = 1;
            columns = [
              (lu [ "label" "label_description" ] // { gap = 1; })
              (lu [ "kind_icon" "kind" ])
            ];
            align_to = "label";
            components = {
              kind_icon = {
                ellipsis = false;
                text.__raw = ''
                  function(ctx)
                    return ctx.kind_icon .. " " .. ctx.icon_gap
                  end
                '';
                highlight.__raw = ''
                  function(ctx)
                    return ctx.kind_hl
                  end
                '';
              };
              label = {
                text.__raw = ''
                  function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end
                '';
                highlight.__raw = ''
                  function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end
                '';
              };
            };
          };
        };
        documentation = {
          auto_show = true;
          window.border = "single";
        };
      };
      signature.enabled = true;
    };
  };
}
