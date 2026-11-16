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

  # Insert-mode <CR> is broken in org buffers: `org_return` falls back to the
  # global <CR> mapping, which is blink.pairs' expr callback returning
  # `<C-]><CR>`; org evaluates that as an expression and fails with
  # `E15: Invalid expression`, so Enter inserts nothing. Replace it with a
  # wrapper that keeps org's table-row behaviour and otherwise feeds a real
  # <CR>. Runs on a scheduled callback so it lands after org's ftplugin and
  # blink.cmp wraps it as its accept fallback.
  extraConfigLua = ''
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
