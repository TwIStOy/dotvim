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
        nixvimNvx = nixvim'.makeNixvimWithModule nixvimModule;
        nvx =
          pkgs.runCommand "nvx" {
            nativeBuildInputs = [pkgs.makeWrapper];
          } ''
            mkdir -p $out/bin
            makeWrapper ${lib.getExe nixvimNvx} $out/bin/nvx \
              --set NVIM_APPNAME nvx
          '';
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        formatter = nixpkgs.legacyPackages.${system}.alejandra;

        packages.default = nvx;
      };
    };
}
