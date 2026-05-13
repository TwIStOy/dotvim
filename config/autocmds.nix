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
    {
      event = ["FileType"];
      pattern = "*";
      callback.__raw = ''
        function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          local parser = vim.treesitter.get_parser(ev.buf, lang, { error = false })
          if parser ~= nil then
            vim.treesitter.start(ev.buf, lang)
          end
        end
      '';
      desc = "Start treesitter automatically for supported filetypes";
    }
  ];
}
