{pkgs, ...}: {
  # codediff.nvim — VSCode-style diff rendering (side-by-side + inline) with
  # two-tier highlighting. The nixpkgs package builds the libvscode-diff C
  # library at build time, so no runtime binary download is needed.
  #
  # Lazy-loaded on the :CodeDiff command. The package is added with
  # `optional = true` so nixvim places it under pack/.../opt/ (not auto-sourced
  # at startup), and lz.n loads it on demand. The lz.n spec name must match the
  # pack/opt folder, which is lib.getName of the package ("codediff.nvim").
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.codediff-nvim;
      optional = true;
    }
  ];

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "codediff.nvim";
      cmd = ["CodeDiff"];
      after.__raw = ''
        function()
          require("codediff").setup({ explorer = { view_mode = "tree" } })
        end
      '';
    }
  ];
}
