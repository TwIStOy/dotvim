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

    # LSP
    # (nraw "gD" (lsp "declaration") "goto-declaration")
    # (nraw "gd" (lsp "definitions") "goto-definitions")
    # (nraw "gt" (lsp "type_definitions") "goto-type-definitions")
    # (nraw "gi" (lsp "implementations") "goto-implementations")
    # (nraw "gr" (lsp "references") "goto-references")
    # (nraw "ga" (lsp "code_action") "code-action")
    # (nraw "gR" (lsp "rename") "rename-symbol")
    # (nraw "<leader>oi" (lsp "organize_imports") "organize-imports")
    # (nraw "K" (lsp "show_hover") "show-hover")
    # (nraw "<leader>ss" (lsp "document_symbols") "document-symbols")
    # (nraw "<leader>sw" (lsp "workspace_symbols") "workspace-symbols")
    # (nraw "<leader>sW" (lsp "workspace_symbols_cword") "workspace-symbols-cword")
    # (nraw "]c" (lsp "next_diagnostic") "goto-next-error")
    # (nraw "[c" (lsp "prev_diagnostic") "goto-prev-error")
    # (nraw "]d" (lsp "next_diagnostic_all") "goto-next-diagnostic")
    # (nraw "[d" (lsp "prev_diagnostic_all") "goto-prev-diagnostic")
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
