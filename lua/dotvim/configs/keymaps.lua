---@module "dotvim.configs.keymaps"

-- Disable arrow keys
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

-- Basic file operations
vim.keymap.set("n", "<leader>fs", "<cmd>update<CR>", { desc = "save" })

-- Clear search highlighting
vim.keymap.set("n", "<M-n>", "<cmd>nohl<CR>", { desc = "nohl" })

-- Quit commands
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "quit-all" })

-- Window management (non-vscode)
if not vim.g.vscode then
  vim.keymap.set("n", "<leader>wv", "<cmd>wincmd v<CR>", { desc = "split-window-vertical" })
  vim.keymap.set("n", "<leader>w-", "<cmd>wincmd -<CR>", { desc = "split-window-horizontal" })
  vim.keymap.set("n", "<leader>w=", "<cmd>wincmd =<CR>", { desc = "balance-window" })
  vim.keymap.set("n", "<leader>wr", "<cmd>wincmd r<CR>", { desc = "rotate-window-rightwards" })
  vim.keymap.set("n", "<leader>wx", "<cmd>wincmd x<CR>", { desc = "exchange-window-with-next" })
  
  -- Function to check if a window contains source code
  local function is_source_window(winid)
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    
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
      "NvimTree", "neo-tree", "nerdtree",
      "Trouble", "qf", "help", "man",
      "Outline", "tagbar", "aerial",
      "dap-repl", "dapui_console", "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes",
      "telescope", "TelescopePrompt",
      "oil", "fugitive", "git",
      "alpha", "dashboard", "startify"
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
    vim.keymap.set("n", "<leader>" .. i, function()
      jump_to_source_window(i)
    end, { desc = "jump-to-window-" .. i })
  end
end
