local Const = require("ht.core.const")

local ui_lhs = function(tui, gui)
  if Const.is_gui then
    return gui
  else
    return tui
  end
end

local function setup()
  -- Disable arrows
  vim.api.nvim_set_keymap("", "<Left>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Right>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Up>", "<Nop>", {})
  vim.api.nvim_set_keymap("", "<Down>", "<Nop>", {})

  NMAP("<leader>wv", "<cmd>wincmd v<CR>", "split-window-vertical")

  NMAP("<leader>w-", "<cmd>wincmd s<CR>", "split-window-horizontal")

  NMAP("<leader>w=", "<cmd>wincmd =<CR>", "balance-window")

  NMAP("<leader>wr", "<cmd>wincmd r<CR>", "rotate-window-rightwards")

  NMAP("<leader>wx", "<cmd>wincmd x<CR>", "exchange-window-with-next")

  for i = 1, 9 do
    NMAP("<leader>" .. i, function()
      require("ht.core.window").goto_window(i)
    end, "goto-win-" .. i)
  end

  NMAP("<leader>fs", "<cmd>update<CR>", "update")
  if not Const.is_gui then
    vim.keymap.set(
      { "n", "i", "v" },
      "<Char-0xAA>",
      "<cmd>update<CR>",
      { silent = true }
    )
  else
    vim.keymap.set(
      { "n", "i", "v" },
      "<D-s>",
      "<cmd>update<CR>",
      { silent = true }
    )
  end

  if Const.is_gui then
    -- paste from system clipboard using <cmd-v>
    vim.keymap.set({ "n", "i" }, "<D-v>", function()
      local register_info = vim.fn.getreginfo("+")
      local content = {}
      if register_info.regcontents then
        content = register_info.regcontents
      end
      vim.api.nvim_put(content, "", true, true)
    end, { silent = true })
  end

  NMAP("<M-n>", "<cmd>nohl<CR>", "nohl")

  NMAP("<leader>q", "<cmd>q<CR>", "quit")
  NMAP("<leader>Q", "<cmd>confirm qall<CR>", "quit-all")

  NMAP("<C-p>", function()
    require("telescope").extensions.command_palette.command_palette {
      layout_strategy = "center",
      sorting_strategy = "ascending",
      layout_config = {
        anchor = "N",
        width = 0.5,
        prompt_position = "top",
        height = 0.5,
      },
      border = true,
      results_title = false,
      -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      borderchars = {
        prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    }
  end, "open-command-palette")

  NMAP(";;", function()
    require("htts").onRightClick()
  end)
end

return {
  setup = setup,
  ui_lhs = ui_lhs,
}
