return function()
  ---@type dora.config
  local config = require("dora.config")

  ---@type dora.lib
  local lib = require("dora.lib")

  -- Disable arrows
  vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

  if lib.vim.current_gui() == "vscode" then
    vim.keymap.set("n", "<leader>1", function()
      require("vscode-neovim").call("workbench.action.focusFirstEditorGroup")
    end, { desc = "goto-win-1" })
    vim.keymap.set("n", "<leader>2", function()
      require("vscode-neovim").call("workbench.action.focusSecondEditorGroup")
    end, { desc = "goto-win-2" })
    vim.keymap.set("n", "<leader>3", function()
      require("vscode-neovim").call("workbench.action.focusThirdEditorGroup")
    end, { desc = "goto-win-3" })
  else
    vim.keymap.set("n", "<leader>wv", "<cmd>wincmd v<CR>", {
      desc = "split-window-vertical",
    })

    vim.keymap.set("n", "<leader>w-", "<cmd>wincmd s<CR>", {
      desc = "split-window-horizontal",
    })

    vim.keymap.set("n", "<leader>w=", "<cmd>wincmd =<CR>", {
      desc = "balance-window",
    })

    vim.keymap.set("n", "<leader>wr", "<cmd>wincmd r<CR>", {
      desc = "rotate-window-rightwards",
    })

    vim.keymap.set("n", "<leader>wx", "<cmd>wincmd x<CR>", {
      desc = "exchange-window-with-next",
    })

    local function goto_countable_window(i)
      local function skip_uncountable_windows(cnt)
        local rest = cnt

        for _, win_id in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          if
            not config.vim.is_uncountable(win_id)
            and vim.api.nvim_win_is_valid(win_id)
          then
            rest = rest - 1
            if rest == 0 then
              return win_id
            end
          end
        end

        return 0
      end

      vim.schedule(function()
        local win_id = skip_uncountable_windows(i)
        if win_id > 0 then
          vim.api.nvim_set_current_win(win_id)
        end
      end)
    end

    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function()
        goto_countable_window(i)
      end, { desc = "goto-win-" .. i })
    end
  end

  vim.keymap.set("n", "<leader>fs", "<cmd>update<CR>", { desc = "update" })

  vim.keymap.set("n", "<M-n>", "<cmd>nohl<CR>", { desc = "nohl" })

  vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "quit" })
  vim.keymap.set(
    "n",
    "<leader>Q",
    "<cmd>confirm qall<CR>",
    { desc = "quit-all" }
  )
end
