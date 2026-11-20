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
          -- nvim-treesitter is deferred (see plugins/treesitter): it loads
          -- via the `User DotvimTreesitter` trigger the first time a real
          -- file with a parser is opened. Parsers/queries stay available
          -- before that through the eager nvim-treesitter-grammars package.
          -- NOTE: vim.g only persists scalars reliably (tables are copied
          -- on read), hence the boolean flag.
          if vim.g.dotvim_ts_loaded then
            -- nvim-treesitter is up; start immediately for new buffers
            local lang = vim.treesitter.language.get_lang(ev.match)
            if lang and vim.treesitter.language.add(lang) then
              pcall(vim.treesitter.start, ev.buf, lang)
            end
            return
          end

          -- Before nvim-treesitter is loaded, filetype->language aliases
          -- from its plugin/filetypes.lua are not registered yet, so a nil
          -- lang here does not mean "no parser": it may resolve after load.
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          if not vim.treesitter.get_parser(ev.buf, lang, { error = false }) then
            return
          end

          -- A real file with a treesitter parser was opened: load
          -- nvim-treesitter now, then attach to all listed buffers (covers
          -- buffers already opened and alias filetypes skipped above).
          vim.g.dotvim_ts_loaded = true
          vim.api.nvim_exec_autocmds("User", {
            pattern = "DotvimTreesitter",
            modeline = false,
          })
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local buf_ft = vim.bo[buf].filetype
              local buf_language = vim.treesitter.language.get_lang(buf_ft or "")
              if buf_language and vim.treesitter.language.add(buf_language) then
                if not vim.treesitter.highlighter.active[buf] then
                  pcall(vim.treesitter.start, buf, buf_language)
                end
              end
            end
          end
        end
      '';
      desc = "Start treesitter automatically for supported filetypes (deferred)";
    }
    {
      event = ["BufReadPost"];
      pattern = "*";
      callback.__raw = ''
        function(event)
          local full_path = vim.api.nvim_buf_get_name(event.buf)
          local tesla_firmware_path_pattern = "[Tt]esla%d*/firmware"
          local tesla_firmware_path_pattern2 = "works/firmwares"
          if string.match(full_path, tesla_firmware_path_pattern) or string.match(full_path, tesla_firmware_path_pattern2) then
            vim.bo[event.buf].fixendofline = false
            vim.bo[event.buf].tabstop = 4
            vim.bo[event.buf].shiftwidth = 4
          end
        end
      '';
      desc = "Disable eol and use 4-space indent for Tesla firmware files";
    }
    {
      event = ["BufWritePre"];
      pattern = "*";
      callback.__raw = ''
        function(event)
          -- Skip remote/special buffers (e.g. scp://, term://)
          if vim.bo[event.buf].buftype ~= "" or event.match:match("^%w+://") then
            return
          end
          local dir = vim.fn.fnamemodify(event.match, ":p:h")
          if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
          end
        end
      '';
      desc = "Create parent directories with mkdir -p on save if missing";
    }
    {
      event = ["SessionLoadPost"];
      pattern = "*";
      callback.__raw = ''
        function()
          -- Sessions restore neo-tree windows as dead clone buffers:
          -- mksession writes `file neo-tree\ filesystem\ \[1]` for the
          -- sidebar, and sourcing it (after :restart or `nvim -S`)
          -- recreates a buffer with that name. When neo-tree opens its
          -- sidebar via NuiSplit it names its own buffer without a reuse
          -- check, so the clone collides and neo-tree dies with
          -- "Vim:E95: Buffer with this name already exists". Wipe the
          -- clones and reopen a live tree instead.
          if package.loaded["neo-tree"] then
            return
          end
          vim.schedule(function()
            local is_clone = function(buf)
              if not vim.api.nvim_buf_is_valid(buf) then
                return false
              end
              return vim.api
                .nvim_buf_get_name(buf)
                :match("neo%-tree %S+ %[[^%]]+%]$") ~= nil
            end

            local clone_wins = vim.tbl_filter(function(win)
              local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
              return ok and is_clone(buf)
            end, vim.api.nvim_list_wins())

            local clone_bufs = vim.tbl_filter(is_clone, vim.api.nvim_list_bufs())
            if #clone_bufs == 0 then
              return
            end

            local source = vim.api
              .nvim_buf_get_name(clone_bufs[1])
              :match("neo%-tree (%S+) %[[^%]]+%]$")

            -- Close the dead windows (or blank them when the tree was the
            -- only window), then wipe the clone buffers so neo-tree can
            -- create its own without the name colliding.
            local has_other = #vim.api.nvim_list_wins() > #clone_wins
            for _, win in ipairs(clone_wins) do
              if vim.api.nvim_win_is_valid(win) then
                if has_other then
                  pcall(vim.api.nvim_win_close, win, false)
                else
                  vim.api.nvim_win_call(win, function()
                    vim.cmd("enew")
                  end)
                end
              end
            end
            for _, buf in ipairs(clone_bufs) do
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end

            -- Reopen a live tree; the Neotree command stub lazy-loads it.
            local known = { filesystem = true, buffers = true, git_status = true }
            if source == nil or not known[source] then
              source = "filesystem"
            end
            vim.cmd(("Neotree source=%s show"):format(source))
          end)
        end
      '';
      desc = "Replace dead session-restored neo-tree buffers with a live tree";
    }
  ];
}
