local function disable_key(key)
  vim.api.nvim_set_keymap("", key, "<Nop>", {})
end

local function nmap(key, cmd, desc)
  vim.keymap.set("n", key, cmd, { desc = desc })
end

-- Disable arrow keys
disable_key("<Left>")
disable_key("<Right>")
disable_key("<Up>")
disable_key("<Down>")

-- Basic file operations
nmap("<leader>fs", "<cmd>update<CR>", "save")

-- Snacks picker keymaps (non-vscode)
if not vim.g.vscode then
  local picker = require("dotvim.features.snacks_picker")

  nmap("<leader>e", picker.find_files, "edit-project-files")
  nmap("g/", picker.live_grep, "live-grep")
  nmap("<leader>lg", picker.live_grep, "live-grep")
  nmap("<F4>", picker.buffers, "all-buffers")
end

-- Clear search highlighting
nmap("<M-n>", "<cmd>nohl<CR>", "nohl")

-- Quit commands
nmap("<leader>q", "<cmd>q<CR>", "quit")
nmap("<leader>Q", "<cmd>confirm qall<CR>", "quit-all")

-- Window management (non-vscode)
if not vim.g.vscode then
  nmap("<leader>wv", "<cmd>wincmd v<CR>", "split-window-vertical")
  nmap("<leader>w-", "<cmd>wincmd s<CR>", "split-window-horizontal")
  nmap("<leader>w=", "<cmd>wincmd =<CR>", "balance-window")
  nmap("<leader>wr", "<cmd>wincmd r<CR>", "rotate-window-rightwards")
  nmap("<leader>wx", "<cmd>wincmd x<CR>", "exchange-window-with-next")

  -- Function to check if a window contains source code
  local function is_source_window(winid)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    -- Skip special buffer types
    if buftype ~= "" then
      return false
    end

    -- Skip floating windows
    local config = vim.api.nvim_win_get_config(winid)
    if config.relative ~= "" then
      return false
    end

    -- Skip common tool windows by filetype
    local tool_filetypes = {
      "NvimTree",
      "neo-tree",
      "nerdtree",
      "Trouble",
      "qf",
      "help",
      "man",
      "Outline",
      "tagbar",
      "aerial",
      "dap-repl",
      "dapui_console",
      "dapui_watches",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_scopes",
      "telescope",
      "TelescopePrompt",
      "oil",
      "fugitive",
      "git",
      "alpha",
      "dashboard",
      "startify",
    }

    for _, ft in ipairs(tool_filetypes) do
      if filetype == ft then
        return false
      end
    end

    return true
  end

  -- Function to jump to source window by index
  local function jump_to_source_window(index)
    local all_windows = vim.api.nvim_list_wins()
    local source_windows = {}

    -- Collect only source code windows
    for _, winid in ipairs(all_windows) do
      if is_source_window(winid) then
        table.insert(source_windows, winid)
      end
    end

    -- Jump to the specified window if it exists
    if index <= #source_windows then
      vim.api.nvim_set_current_win(source_windows[index])
    end
  end

  -- Window navigation by index (only source windows)
  for i = 1, 9 do
    nmap("<leader>" .. i, function()
      jump_to_source_window(i)
    end, "jump-to-window-" .. i)
  end
end

-- LSP keymaps (non-vscode)
if not vim.g.vscode then
  local features = require("dotvim.features")

  -- LSP method keybindings
  nmap("gD", features.lsp_methods.declaration, "goto-declaration")
  nmap("gd", features.lsp_methods.definitions, "goto-definitions")
  nmap("gt", features.lsp_methods.type_definitions, "goto-type-definitions")
  nmap("gi", features.lsp_methods.implementations, "goto-implementations")
  nmap("gr", features.lsp_methods.references, "goto-references")
  nmap("ga", features.lsp_methods.code_action, "code-action")
  nmap("gR", features.lsp_methods.rename, "rename-symbol")
  nmap("<leader>oi", features.lsp_methods.organize_imports, "organize-imports")
  nmap("K", features.lsp_methods.show_hover, "show-hover")
  nmap("<leader>ss", features.lsp_methods.document_symbols, "document-symbols")
  nmap(
    "<leader>sw",
    features.lsp_methods.workspace_symbols,
    "workspace-symbols"
  )
  nmap(
    "<leader>sW",
    features.lsp_methods.workspace_symbols_cword,
    "workspace-symbols-cword"
  )

  -- Diagnostic navigation keybindings
  nmap("]c", features.lsp_methods.next_diagnostic, "goto-next-error")
  nmap("[c", features.lsp_methods.prev_diagnostic, "goto-prev-error")
  nmap("]d", features.lsp_methods.next_diagnostic_all, "goto-next-diagnostic")
  nmap("[d", features.lsp_methods.prev_diagnostic_all, "goto-prev-diagnostic")
end
