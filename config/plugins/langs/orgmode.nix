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
          -- conflicts). Link to the active theme's semantic groups instead
          -- of baking in a palette. Direct links inherit all target attrs:
          -- state strike_through values below remain as intent, but cannot
          -- add strikethrough/bold on top of a link.
          local links = {
            OrgSA_TODO = "DiffDelete",
            OrgSA_WAITING = "DiffText",
            OrgSA_PROCESSING = "DiffChange",
            OrgSA_DONE = "DiffAdd",
            OrgSA_CANCEL = "Comment",
            OrgSA_NONE = "Comment",
            OrgSA_Marked = "Visual",
            OrgSA_Clock = "Special",
            OrgSA_Group = "Title",
            OrgSA_TreeConnector = "NonText",
            OrgSA_TreeGhost = "Comment",
          }
          local function apply_links()
            for group, target in pairs(links) do
              vim.api.nvim_set_hl(0, group, { link = target })
            end
          end
          -- Set these before the plugin's highlight-default initialization.
          -- Its cached ensure() will not restore groups after ColorScheme.
          apply_links()
          vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("dotvim_org_super_agenda_links", { clear = true }),
            callback = apply_links,
          })
          local function state(name, keymap, strike)
            return {
              name = name,
              keymap = keymap,
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
              state("TODO", "ot", false),
              state("WAITING", "ow", false),
              state("PROCESSING", "op", false),
              state("DONE", "od", true),
              state("CANCEL", "oc", true),
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
