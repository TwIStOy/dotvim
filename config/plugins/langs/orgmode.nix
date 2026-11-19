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
      org_startup_folded = "showeverything";
      org_agenda_files = "~/org/**/*";
      org_default_notes_file = "~/org/inbox.org";
      org_todo_keywords = [
        "TODO(t)"
        "WAITING(w)"
        "PROCESSING(p)"
        "|"
        "DONE(d)"
        "CANCEL(c)"
      ];
      mappings.org.org_open_at_point = "gd";
    };
  };

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
          -- todo_states mirror orgmode's org_todo_keywords above. `keymap`
          -- is the in-agenda quick filter; each state's first letter doubles
          -- as the direct-set shortcut (`st`/`sw`/`sp`/`sd`/`sc`, no
          -- conflicts). Colors follow the active catppuccin flavour
          -- (latte/mocha via OSC 11); the hex literals are mid-tone
          -- fallbacks for other colorschemes.
          local palette = {}
          pcall(function()
            palette = require("catppuccin.palettes").get_palette()
          end)
          local function state(name, keymap, hue, fallback, strike)
            return {
              name = name,
              keymap = keymap,
              color = type(palette) == "table" and palette[hue] or fallback,
              strike_through = strike,
              fields = {
                "filename", "todo", "headline", "priority", "date", "tags",
              },
            }
          end

          require("org-super-agenda").setup({
            backend = "orgmode",
            -- `ov` still cycles classic/compact/tree inside the agenda
            view_mode = "compact",
            todo_states = {
              state("TODO", "ot", "red", "#ed8796", false),
              state("WAITING", "ow", "mauve", "#ca9ee6", false),
              state("PROCESSING", "op", "peach", "#f5a97f", false),
              state("DONE", "od", "green", "#a6d189", true),
              state("CANCEL", "oc", "overlay0", "#737994", true),
            },
          })
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
