{lib, ...}:
with lib; let
  nixConfig = {
    pkgs = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Plugins managed by nix package";
    };
    bin = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Binaries managed by nix package";
    };
  };

  packagesConfig = mkOption {
    type = types.listOf types.str;
    description = "Enabled dora packages";
    default = [
      "dora.packages._builtin"
      "dora.packages.coding"
      "dora.packages.editor"
      "dora.packages.treesitter"
      "dora.packages.lsp"
      "dora.packages.ui"
    ];
  };

  integrationConfig = {
    enable_yazi = mkEnableOption "Yazi integration";
    enable_lazygit = mkEnableOption "Lazygit integration";
  };

  toLuaObject = args:
    if builtins.isList args
    then "{" + (builtins.concatStringsSep ", " (map toLuaObject args)) + "}"
    else if builtins.isAttrs args
    then
      "{"
      + (
        builtins.concatStringsSep ", " (
          lib.mapAttrsToList (name: value: "[${toLuaObject name}] = ${toLuaObject value}") args
        )
      ) "}"
    else if builtins.isString args
    then builtins.toJSON args
    else if builtins.isPath args
    then builtins.toJSON (toString args)
    else if builtins.isBool args
    then "${boolToString args}"
    else if builtins.isFloat args
    then "${toString args}"
    else if builtins.isInt args
    then "${toString args}"
    else "nil";
in {
  options = {
    program.dora-nvim = {
      enable = mkEnableOption "dora-nvim";

      rev = mkOption {
        type = types.str;
        description = "dora.nvim rev";
        default = "267ed0aef4b54a13317ccc72350bcaccbcac7c4e";
      };

      settings = {
        nix = nixConfig;
        packages = packagesConfig;
        integration = integrationConfig;
      };

      extraConfig = mkOption {
        type = types.str;
        description = "Extra init config";
        default = "";
      };
    };
  };

  config = let
    initLuaText = ''
      vim.loader.enable()
      vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/dora.nvim")
      local dora = require("dora")
      dora.setup(${toLuaObject cfg.settings})
      ${cfg.extraConfig}
    '';
  in (mkIf cfg.enable {
    xdg.configFile."nvim/init.lua" = {
      text = initLuaText;
    };

    xdg.dataFile."nvim/dora.nvim" = {
      source = builtins.fetchGit {
        url = "https://github.com/TwIStOy/dora.nvim.git";
        rev = cfg.rev;
      };
    };
  });
}
