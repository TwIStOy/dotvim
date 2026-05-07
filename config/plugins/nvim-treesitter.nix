{config, ...}: {
  plugins.treesitter = {
    enable = true;
    nixGrammars = true;
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      cpp
      lua
      rust
      nix
      typescript
      dart
      go
    ];
  };
}
