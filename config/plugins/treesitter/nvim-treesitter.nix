{
  config,
  pkgs,
  utils,
  ...
}: let
  queries = utils.path.pathFromRoot "queries";
  pidl-grammar = pkgs.tree-sitter.buildGrammar {
    language = "pidl";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "TwIStOy";
      repo = "tree-sitter-pidl";
      rev = "c6493cf9d5989856e0e4a33ee3ac7262942e59ab";
      hash = "sha256-27dN01uR0rU63ZaN6TL03kll/GPPXu7KgBF/Qys4YCA=";
    };
  };
  kafel-grammar = pkgs.tree-sitter.buildGrammar {
    language = "kafel";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "TwIStOy";
      repo = "tree-sitter-kafel";
      rev = "a655bc0a0dc4caf2cd2ced75aee7ec2b9eeae383";
      hash = "sha256-MDdrQTw6fWIPYFK7lnYMgIF8Nmz/1pzzWOfzxY8nGQI=";
    };
  };
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
    ] ++ [
      pidl-grammar
      kafel-grammar
    ];
  };
}
