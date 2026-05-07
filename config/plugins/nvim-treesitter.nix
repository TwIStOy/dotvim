{config, ...}: let
  queries = ./../../queries;
in {
  extraFiles = {
    "queries/cpp/textobjects.scm".source = queries + "/cpp/textobjects.scm";
    "queries/cpp/folds.scm".source = queries + "/cpp/folds.scm";
    "queries/cpp/luasnip.scm".source = queries + "/cpp/luasnip.scm";
    "queries/rust/textobjects.scm".source = queries + "/rust/textobjects.scm";
    "queries/go/textobjects.scm".source = queries + "/go/textobjects.scm";
    "queries/typescript/textobjects.scm".source = queries + "/typescript/textobjects.scm";
    "queries/dart/textobjects.scm".source = queries + "/dart/textobjects.scm";
    "queries/lua/textobjects.scm".source = queries + "/lua/textobjects.scm";
  };

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
