{lib, ...}: let
  lu = lib.nixvim.utils.listToUnkeyedAttrs;
in {
  plugins.blink-pairs = {
    enable = true;
    autoLoad = true;
    settings = {
      highlights.enabled = true;
      mappings = {
        enabled = true;
        pairs = {
          "\"" = [
            (lu [''r#"'' ''"#'']
              // {
                languages = ["rust"];
                priority = 100;
              })
            (lu [''"""'']
              // {
                when.__raw = ''
                  function(ctx)
                    return ctx:text_before_cursor(2) == '""'
                  end
                '';
                languages = ["python" "elixir" "julia" "kotlin" "scala"];
              })
            (lu [''"'']
              // {
                enter = false;
                space = false;
                when.__raw = ''
                  function(ctx)
                    return ctx:text_before_cursor(1) ~= "#"
                  end
                '';
              })
          ];
          "<" = [
            (lu ["<" ">"]
              // {
                when.__raw = ''
                  function(ctx)
                    return ctx.ts:whitelist("angle").matches
                  end
                '';
                languages = ["rust"];
              })
            (lu ["<" ">"]
              // {
                when.__raw = ''
                  function(ctx)
                    local text_before_cursor = ctx:text_before_cursor(1)
                    return text_before_cursor ~= "#"
                      and text_before_cursor ~= " "
                      and text_before_cursor ~= "<"
                  end
                '';
                languages = ["cpp"];
              })
          ];
        };
      };
    };
  };
}
