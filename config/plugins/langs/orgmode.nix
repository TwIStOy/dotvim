{pkgs, ...}: let
  org-super-agenda = pkgs.vimUtils.buildVimPlugin {
    pname = "org-super-agenda.nvim";
    version = "2.2.0";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "hamidi-dev";
      repo = "org-super-agenda.nvim";
      rev = "2bbf8d0c6f934a06352826db5b792944e0761c0e";
      hash = "sha256-rD3GCtzQ8MJKzGKASLrtNAIPS/xulRhhIkmfV/9BuRs=";
    };
  };
  org-bullets = pkgs.vimUtils.buildVimPlugin {
    pname = "org-bullets.nvim";
    version = "0-unstable-2026-03-24";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "503fe053550879cc202086a40454e46a87c41ddb";
      hash = "sha256-Tgeqr/Zd1hJXXaln4XWGS5aZqypnpfNxgO/+pQVk7jg=";
    };
  };
in {
  extraPlugins = [
    {
      plugin = org-super-agenda;
      optional = true;
    }
    {
      plugin = org-bullets;
      optional = true;
    }
  ];

  plugins.orgmode = {
    enable = true;
    settings = {
      # orgmode sets `foldlevel` from this in ftplugin/org.lua, overriding the
      # global `foldlevelstart`. Show every fold by default.
      org_startup_folded = "showeverything";
      org_agenda_files = "~/org/**/*";
      org_default_notes_file = "~/org/inbox.org";
      mappings.org.org_open_at_point = "gd";
    };
  };

  # Two orgmode fixes share the FileType hook:
  # 1. insert-mode <CR>: `org_return` falls back to the global <CR> mapping,
  #    which is blink.pairs' expr callback returning `<C-]><CR>`; org evaluates
  #    that as an expression and fails with `E15: Invalid expression`, so
  #    Enter inserts nothing. Replace it with a wrapper that keeps org's
  #    table-row behaviour and otherwise feeds a real <CR>.
  # 2. text objects: org registers `ih`/`ir`/`i*`/... without a description, so
  #    which-key falls back to printing the raw rhs. Describe them
  #    buffer-locally (they shadow treesitter-textobjects only inside org
  #    buffers); the ` oi`/` ol`/` ox` sub-prefix group names live in
  #    which-key.nix.
  # Both run on a scheduled callback so they land after org's ftplugin and
  # blink.cmp wraps the <CR> one as its accept fallback.
  extraConfigLua = ''
    local org_text_object_descriptions = {
      ih = "select-inner-heading",
      ah = "select-around-heading",
      ir = "select-inner-subtree",
      ar = "select-around-subtree",
      Oh = "select-inner-heading-from-root",
      OH = "select-around-heading-from-root",
      Or = "select-inner-subtree-from-root",
      OR = "select-around-subtree-from-root",
      ["i*"] = "select-inner-bold",
      ["a*"] = "select-around-bold",
      ["i/"] = "select-inner-italic",
      ["a/"] = "select-around-italic",
      ["i+"] = "select-inner-strikethrough",
      ["a+"] = "select-around-strikethrough",
      ["i_"] = "select-inner-underline",
      ["a_"] = "select-around-underline",
      ["i="] = "select-inner-verbatim",
      ["a="] = "select-around-verbatim",
      ["i~"] = "select-inner-code",
      ["a~"] = "select-around-code",
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "org",
      callback = function(args)
        vim.schedule(function()
          vim.keymap.set("i", "<CR>", function()
            local element = require("orgmode.files.elements.table").from_current_node()
            if element and element:handle_cr() then
              return
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
          end, { buffer = args.buf, desc = "org-return" })

          for _, mode in ipairs({ "x", "o" }) do
            for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, mode)) do
              local desc = org_text_object_descriptions[map.lhs]
              if desc and (map.desc == nil or map.desc == "") then
                vim.api.nvim_buf_set_keymap(args.buf, mode, map.lhs, map.rhs, {
                  desc = desc,
                  nowait = map.nowait == 1,
                  silent = map.silent == 1,
                  noremap = map.noremap == 1,
                })
              end
            end
          end
        end)
      end,
    })
  '';

  plugins.render-markdown = {
    enable = true;
    lazyLoad.settings.ft = [
      "markdown"
      "org"
    ];
    settings.file_types = [
      "markdown"
      "org"
    ];
  };

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "org-super-agenda.nvim";
      cmd = "OrgSuperAgenda";
      after.__raw = ''
        function()
          require("org-super-agenda").setup({ backend = "orgmode" })
        end
      '';
    }
    {
      __unkeyed-1 = "org-bullets.nvim";
      ft = "org";
      after.__raw = ''
        function()
          require("org-bullets").setup()
        end
      '';
    }
  ];
}
