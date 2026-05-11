{
  description = "Neovim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        system,
        pkgs,
        self,
        lib,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        utils = import ./lib {inherit inputs;};
        configArguments =
          {
            inherit utils;
          }
          // inputs;
        nixvimModule = {
          inherit pkgs;
          module = import ./config configArguments;
          extraSpecialArgs = {
            inherit utils;
          };
        };
        nixvimNe = nixvim'.makeNixvimWithModule nixvimModule;
        printInit = nixvimNe.passthru.config.build.printInitPackage;
        ne =
          pkgs.runCommand "ne" {
            nativeBuildInputs = [pkgs.makeWrapper];
          } ''
            mkdir -p $out/bin
            makeWrapper ${lib.getExe nixvimNe} $out/bin/ne \
              --set NVIM_APPNAME ne
            ln -s ${lib.getExe printInit} $out/bin/nixvim-print-init
          '';
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        formatter = nixpkgs.legacyPackages.${system}.alejandra;

        packages = {
          default = ne;
          print-init = printInit;
        };
      };
    };
}
