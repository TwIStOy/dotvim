{nixpkgs, ...}: let
  isVimTemplateFile = path:
    nixpkgs.lib.strings.hasPrefix ".vim-template:" path;
  isDefaultNix = path: path == "default.nix";
  # check if the file is a nix file, but skip `default.nix` and 'vim-template' files
  isNixFile = path:
    !(isDefaultNix path)
    && !(isVimTemplateFile path)
    && nixpkgs.lib.strings.hasSuffix ".nix" path;
  # check if the directory contains a default.nix file
  directoryContainsDefaultNix = path:
    builtins.pathExists
    (path + "/default.nix");
  # check if the attribute is a nix module
  mkIfNixModule = root: path: filetype: let
    fullPath = root + "/" + path;
  in
    (filetype == "directory" && directoryContainsDefaultNix fullPath)
    || (filetype == "regular" && isNixFile path);
in {
  listModules = path: let
    isNixModule = mkIfNixModule "${path}";
    allFiles = builtins.readDir path;
  in
    builtins.map
    (f: (path + "/${f}"))
    (
      builtins.attrNames
      (nixpkgs.lib.attrsets.filterAttrs isNixModule allFiles)
    );

  pathFromRoot = nixpkgs.lib.path.append ../.;
}
