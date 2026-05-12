{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "darkearth-nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "ptdewey";
        repo = "darkearth-nvim";
        rev = "v2.4.2";
        hash = "sha256-j7pFWOD/pbhjSmSepaWhB94Sawp7uHmkRhZDlo+bzxo=";
      };
    })
  ];
}
