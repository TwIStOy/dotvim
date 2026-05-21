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
    {
      event = ["BufReadPost"];
      pattern = "*";
      callback.__raw = ''
        function(event)
          local full_path = vim.api.nvim_buf_get_name(event.buf)
          local tesla_firmware_path_pattern = "[Tt]esla%d*/firmware"
          if string.match(full_path, tesla_firmware_path_pattern) then
            vim.bo[event.buf].fixendofline = false
            vim.bo[event.buf].tabstop = 4
            vim.bo[event.buf].shiftwidth = 4
          end
        end
      '';
      desc = "Disable eol and use 4-space indent for Tesla firmware files";
    }
  ];
}
