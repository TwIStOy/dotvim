{pkgs, ...}: {
  # codesnap.nvim — snapshot the current selection as a pretty PNG/ASCII
  # image. Comes from the plugin's own flake (input `codesnap`), which builds
  # the Rust generator library at build time, so no runtime download happens.
  #
  # Lazy-loaded on the :CodeSnap* commands. `optional = true` keeps the
  # package under pack/.../opt/, and the lz.n spec name must match the opt
  # folder, which is lib.getName of the package ("codesnap.nvim").
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.codesnap-nvim;
      optional = true;
    }
  ];

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "codesnap.nvim";
      cmd = [
        "CodeSnap"
        "CodeSnapSave"
        "CodeSnapASCII"
        "CodeSnapHighlight"
        "CodeSnapHighlightSave"
      ];
      after.__raw = ''
        function()
          require("codesnap").setup({
            snapshot_config = {
              code_config = { font_family = "Monolisa" },
            },
            watermark = { content = "" },
          })
        end
      '';
    }
  ];
}
