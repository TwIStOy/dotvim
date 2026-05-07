_: let
  desc-name = query: let
    cleaned = builtins.replaceStrings ["@"] [""] query;
    parts = builtins.filter builtins.isString (builtins.split "\\." cleaned);
  in
    builtins.concatStringsSep "_" parts;

  lz-key = mode: key: lua-action: desc: {
    __unkeyed-1 = key;
    __unkeyed-2.__raw = lua-action;
    inherit desc mode;
  };

  select-lz-key = key: query:
    lz-key ["o" "x"] key ''
      function()
        require("nvim-treesitter-textobjects.select").select_textobject("${query}", "textobjects")
      end
    '' "select-${desc-name query}";

  move-lz-key = method: key: query:
    lz-key ["n" "o" "x"] key ''
      function()
        require("nvim-treesitter-textobjects.move").${method}("${query}", "textobjects")
      end
    '' "goto-${method}-${desc-name query}";

  move-next-lz = move-lz-key "goto_next_start";
  move-prev-lz = move-lz-key "goto_previous_start";
in {
  plugins.treesitter-textobjects = {
    enable = true;
    lazyLoad.settings = {
      event = ["BufReadPost" "BufNewFile"];
      after.__raw = ''
        function()
          require("nvim-treesitter-textobjects").setup({
            select = {
              lookahead = true,
              selection_modes = {},
            },
            include_surrounding_whitespace = true,
            move = {
              set_jumps = true,
            },
          })
        end
      '';
      keys = [
        (select-lz-key "af" "@function.outer")
        (select-lz-key "if" "@function.inner")
        (select-lz-key "i," "@parameter.inner")
        (select-lz-key "a," "@parameter.outer")
        (select-lz-key "i:" "@assignment.rhs")
        (select-lz-key "il" "@lifetime.inner")
        (select-lz-key "a;" "@statement.outer")
        (select-lz-key "ir" "@dotvim_omni_right.inner")
        (select-lz-key "ic" "@conditional.inner")
        (select-lz-key "ac" "@conditional.outer")
        (lz-key ["n"] "<leader>a" ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
          end
        '' "swap-next-parameter")
        (lz-key ["n"] "<leader>A" ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
          end
        '' "swap-previous-parameter")
        (move-next-lz "]," "@parameter.inner")
        (move-next-lz "]l" "@lifetime.inner")
        (move-next-lz "]f" "@function.outer")
        (move-next-lz "]r" "@dotvim_omni_right.inner")
        (move-prev-lz "[," "@parameter.inner")
        (move-prev-lz "[l" "@lifetime.inner")
        (move-prev-lz "[f" "@function.outer")
        (move-prev-lz "[r" "@dotvim_omni_right.inner")
      ];
    };
  };
}
