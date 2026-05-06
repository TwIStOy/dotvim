{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nixvim.utils) toRawKeys;
in {
  plugins.lspconfig.enable = true;

  lsp = {
    inlayHints.enable = true;

    servers = {
      emmylua_ls = {
        enable = true;
        package = pkgs.emmylua-ls;
      };

      nil_ls = {
        enable = true;
        package = pkgs.nil;
        config.settings = {
          formatting = {
            command = ["alejandra"];
          };
          nix = {
            maxMemoryMB = 2048;
            flake = {
              autoArchive = true;
              autoEvalInputs = false;
            };
          };
        };
      };

      gopls = {
        enable = true;
        package = pkgs.gopls;
      };

      clangd = {
        enable = true;
        package = pkgs.clang-tools;
        config = {
          cmd = [
            "clangd"
            "--clang-tidy"
            "--background-index"
            "--background-index-priority=normal"
            "--ranking-model=decision_forest"
            "--completion-style=detailed"
            "--header-insertion=iwyu"
            "--limit-references=100"
            "--include-cleaner-stdlib"
            "--all-scopes-completion"
            "-j=20"
          ];
          init_options = {
            usePlaceholders = true;
            completeUnimported = true;
            clangdFileStatus = true;
          };
          capabilities = {
            offsetEncoding = ["utf-16"];
          };
        };
      };

      ts_ls = {
        enable = true;
        package = pkgs.typescript-language-server;
        config.settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
          };
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayVariableTypeHintsWhenTypeMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
          };
        };
      };

      bashls = {
        enable = true;
        package = pkgs.bash-language-server;
      };

      zls = {
        enable = true;
        package = pkgs.zls;
      };

      jsonls = {
        enable = true;
        package = pkgs.vscode-langservers-extracted;
      };

      basedpyright = {
        enable = true;
        package = pkgs.basedpyright;
      };

      perlnavigator = {
        enable = true;
        package = pkgs.perlnavigator;
      };

      rust_analyzer = {
        enable = true;
        package = pkgs.rust-analyzer;
        config.settings = {
          "rust-analyzer" = {
            imports = {
              granularity = {
                enforce = true;
                group = "crate";
              };
              prefix = "crate";
            };
            semanticHighlighting = {
              operator = {specialization = {enable = true;};};
              punctuation = {enable = true;};
            };
            inlayHints = {
              typeHints = {enable = false;};
              parameterHints = {enable = false;};
              chainingHints = {enable = false;};
              closingBraceHints = {enable = false;};
              renderColons = false;
            };
            completion = {
              postfix = {enable = false;};
              privateEditable = {enable = false;};
            };
            check = {command = "clippy";};
            files = {
              watcher = "server";
              excludeDirs = [".direnv" ".devenv" "target"];
              watcherExclude = [".direnv" ".devenv" "target"];
            };
            lru = {capacity = 2048;};
          };
        };
      };
    };
  };

  plugins.web-devicons.enable = true;

  diagnostic.settings = {
    signs = {
      text = toRawKeys {
        "vim.diagnostic.severity.ERROR" = "";
        "vim.diagnostic.severity.WARN" = "";
        "vim.diagnostic.severity.INFO" = "󰋼";
        "vim.diagnostic.severity.HINT" = "󰌵";
      };
    };
    severity_sort = true;
    virtual_text = false;
    float = {
      focusable = false;
      style = "minimal";
      border = "rounded";
      source = "always";
      header = "";
      prefix = "";
    };
  };
}
