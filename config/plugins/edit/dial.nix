{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "dial.nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "monaqa";
        repo = "dial.nvim";
        rev = "f2634758455cfa52a8acea6f142dcd6271a1bf57";
        hash = "sha256-J2HU746yz8iHos7od5kIdEUd4/bgAPGwC38fLZ4gK+E=";
      };
    })
  ];

  extraConfigLua = ''
    local augend = require("dial.augend")

    local function define_custom(...)
      return augend.constant.new({
        elements = { ... },
        word = true,
        cyclic = true,
      })
    end

    local commons = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.integer.alias.binary,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%H:%M"],
      define_custom("true", "false"),
      define_custom("yes", "no"),
      define_custom("YES", "NO"),
      define_custom("||", "&&"),
      define_custom("enable", "disable"),
      define_custom("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
      define_custom("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
    }

    require("dial.config").augends:register_group({
      default = commons,
    })

    vim.keymap.set({ "n", "v" }, "<C-a>", function()
      require("dial.map").manipulate("increment", "normal")
    end, { desc = "dial-inc" })

    vim.keymap.set({ "n", "v" }, "<C-x>", function()
      require("dial.map").manipulate("decrement", "normal")
    end, { desc = "dial-dec" })
  '';
}
