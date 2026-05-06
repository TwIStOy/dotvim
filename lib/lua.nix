{lib, ...}: let
  inherit (lib.nixvim) toLuaObject;
in {
  setup = plug: attrs: ''
    require("${plug}").setup(${toLuaObject attrs})
  '';
}
