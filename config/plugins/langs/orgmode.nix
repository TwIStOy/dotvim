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
    settings.mappings.org.org_open_at_point = "gd";
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
