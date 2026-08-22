{pkgs, ...}: {
  # Token: warm, muted colorscheme with dark/light variants selected by
  # 'background' at load time. No setup() call needed. Ships four variants
  # (token, token-flint, token-temper, token-ultra), each with a lualine
  # theme. Requires Neovim 0.12+.
  # Not packaged in nixpkgs, hence buildVimPlugin.
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "token-nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "ThorstenRhau";
        repo = "token";
        rev = "2295780916722584e37be4e371161dec4d930a26";
        hash = "sha256-CDtcImyeI0vdgFqJorvqnLvw1hFDRgm7GsSANXRIglI=";
      };
    })
  ];
}
