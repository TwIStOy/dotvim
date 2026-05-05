_: let
  nop-key = lhs: {
    mode = "n";
    key = lhs;
    action = "<Nop>";
  };

  nmap = lhs: rhs: desc: {
    mode = "n";
    key = lhs;
    action = rhs;
    options = {
      inherit desc;
    };
  };
in {
  globals.mapleader = " ";

  keymaps = [
    (nop-key "<Left>")
    (nop-key "<Right>")
    (nop-key "<Up>")
    (nop-key "<Down>")

    (nmap "<leader>fs" "<cmd>update<CR>" "save")
  ];
}
