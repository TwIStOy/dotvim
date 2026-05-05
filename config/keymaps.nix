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

  nraw = lhs: rhs: desc: {
    mode = "n";
    key = lhs;
    action.__raw = rhs;
    options = {
      inherit desc;
    };
  };
  # lsp = method: "require('dotvim.features.lsp_methods').${method}()";
in {
  globals.mapleader = " ";

  keymaps = [
    (nop-key "<Left>")
    (nop-key "<Right>")
    (nop-key "<Up>")
    (nop-key "<Down>")

    (nmap "<leader>fs" "<cmd>update<CR>" "save")
    (nmap "<M-n>" "<cmd>nohl<CR>" "nohl")
    (nmap "<leader>q" "<cmd>q<CR>" "quit")
    (nmap "<leader>Q" "<cmd>confirm qall<CR>" "quit-all")

    # Window management
    (nmap "<leader>wv" "<cmd>wincmd v<CR>" "split-window-vertical")
    (nmap "<leader>w-" "<cmd>wincmd s<CR>" "split-window-horizontal")
    (nmap "<leader>w=" "<cmd>wincmd =<CR>" "balance-window")
    (nmap "<leader>wr" "<cmd>wincmd r<CR>" "rotate-window-rightwards")
    (nmap "<leader>wx" "<cmd>wincmd x<CR>" "exchange-window-with-next")

    # LSP (gd/gt/gi/gr in glance.nix)
    (nraw "gD" ''function() vim.lsp.buf.declaration() end '' "goto-declaration")
    (nraw "ga" ''function() vim.lsp.buf.code_action() end '' "code-action")
    (nraw "gR" ''function() vim.lsp.buf.rename() end '' "rename-symbol")
    (nraw "<leader>oi" ''
      function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end
    '' "organize-imports")
    (nraw "K" ''function() vim.lsp.buf.hover({ border = "solid" }) end '' "show-hover")
    (nraw "]c" ''
      function()
        vim.diagnostic.jump({
          count = 1, wrap = false, float = false,
          severity = vim.diagnostic.severity.ERROR,
        })
      end
    '' "goto-next-error")
    (nraw "[c" ''
      function()
        vim.diagnostic.jump({
          count = -1, wrap = false, float = false,
          severity = vim.diagnostic.severity.ERROR,
        })
      end
    '' "goto-prev-error")
    (nraw "]d" ''
      function()
        vim.diagnostic.jump({ count = 1, wrap = false, float = false })
      end
    '' "goto-next-diagnostic")
    (nraw "[d" ''
      function()
        vim.diagnostic.jump({ count = -1, wrap = false, float = false })
      end
    '' "goto-prev-diagnostic")
  ];

  extraConfigLuaPre = ''
    local function is_source_window(winid)
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      if buftype ~= "" then return false end
      local config = vim.api.nvim_win_get_config(winid)
      if config.relative ~= "" then return false end
      local tool_filetypes = {
        "NvimTree", "neo-tree", "nerdtree", "Trouble", "qf", "help", "man",
        "Outline", "tagbar", "aerial", "dap-repl", "dapui_console",
        "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes",
        "telescope", "TelescopePrompt", "oil", "fugitive", "git", "alpha",
        "dashboard", "startify",
      }
      for _, ft in ipairs(tool_filetypes) do
        if filetype == ft then return false end
      end
      return true
    end

    local function jump_to_source_window(index)
      local source_windows = {}
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if is_source_window(winid) then
          table.insert(source_windows, winid)
        end
      end
      if index <= #source_windows then
        vim.api.nvim_set_current_win(source_windows[index])
      end
    end
  '';

  extraConfigLua = ''
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function()
        jump_to_source_window(i)
      end, { desc = "jump-to-window-" .. i })
    end
  '';
}
