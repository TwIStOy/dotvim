{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "darkearth-nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "ptdewey";
        repo = "darkearth-nvim";
        rev = "v2.5.1";
        hash = "sha256-whiwZ8YlCwPAkIbubwEPDkD7lwVMGKWqinQIlIXqDmE=";
      };
    })
  ];
}
