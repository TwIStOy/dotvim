{lib, ...}: let
  lu = lib.nixvim.utils.listToUnkeyedAttrs;
  grp = key: name: (lu [key]) // {group = name;};
  grpIcon = key: name: icon:
    (lu [key])
    // {
      group = name;
      inherit icon;
    };
in {
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix";
      layout.align = "center";
      show_help = true;
      plugins.presets.g = false;
      icons = {
        breadcrumb = "»";
        separator = "󰜴";
        group = "+";
        rules = [
          {
            plugin = "neogen";
            icon = " ";
            color = "blue";
          }
          {
            plugin = "neotest";
            icon = "󰙨 ";
            color = "red";
          }
          {
            pattern = "bookmark";
            icon = "󰸕 ";
            color = "yellow";
          }
          {
            plugin = "ssr.nvim";
            icon = " ";
            color = "blue";
          }
          {
            plugin = "vim-illuminate";
            icon = " ";
            color = "grey";
          }
          {
            plugin = "gx.nvim";
            icon = "󰇧 ";
            color = "blue";
          }
          {
            pattern = "delete";
            icon = " ";
            color = "blue";
          }
          {
            pattern = "xray";
            icon = " ";
            color = "purple";
          }
          {
            pattern = "clear";
            icon = " ";
            color = "red";
          }
          {
            pattern = "list";
            icon = " ";
            color = "grey";
          }
          {
            pattern = "hydra";
            icon = " ";
            color = "orange";
          }
          {
            pattern = "HYDRA";
            icon = " ";
            color = "orange";
          }
          {
            pattern = "save";
            icon = " ";
            color = "green";
          }
          {
            pattern = "outline";
            icon = " ";
            color = "purple";
          }
          {
            pattern = "trouble";
            icon = " ";
            color = "yellow";
          }
          {
            pattern = "vcs";
            icon = "󰊢 ";
            color = "red";
          }
          {
            pattern = "conflict";
            icon = " ";
            color = "cyan";
          }
          {
            pattern = "yazi";
            icon = " ";
            color = "yellow";
          }
          {
            pattern = "format";
            icon = " ";
            color = "cyan";
          }
          {
            pattern = "lazygit";
            icon = " ";
            color = "yellow";
          }
          {
            pattern = "open";
            icon = " ";
            color = "cyan";
          }
        ];
      };
      spec = [
        ((lu [
            (grp "<leader>b" "bookmarks")
            (grp "<leader>c" "clear")
            (grp "<leader>f" "file")
            (grpIcon "<leader>h" "local" {
              icon = " ";
              color = "blue";
            })
            (grp "<leader>l" "list")
            (grpIcon "<leader>n" "no" {
              icon = " ";
              color = "red";
            })
            (grp "<leader>p" "preview")
            (grpIcon "<leader>r" "remote" " ")
            (grp "<leader>s" "search")
            (grp "<leader>t" "test/toggle")
            (grp "<leader>v" "vcs")
            (grp "<leader>w" "window")
            (grp "<leader>x" "xray")
            (grp "[" "prev")
            (grp "]" "next")
            (grp "g" "goto")
          ])
          // {mode = ["n" "v"];})
      ];
      win.border = "single";
    };
  };
}
