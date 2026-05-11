{
  autoCmd = [
    {
      event = ["CursorHold"];
      pattern = "*";
      callback.__raw = ''
        function()
          vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor", border = "single" })
        end
      '';
      desc = "Show diagnostic in a single bordered floating window";
    }
  ];
}
