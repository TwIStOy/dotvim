---@type dotvim.utils
local Utils = require("dotvim.utils")

---@type dotvim.core.plugin.PluginOption
return {
  "hedyhli/outline.nvim",
  config = function(_, opts)
    local Outline = require("outline")
    Outline.setup(opts)
    local outline_follow = Utils.fn.throttle(2000, function()
      Outline.follow_cursor {
        focus_outline = false,
      }
    end)
    local outline_refresh = Utils.fn.throttle(2000, function()
      Outline.refresh()
    end)

    vim.api.nvim_create_autocmd({
      "InsertLeave",
      "WinEnter",
      "BufEnter",
      "BufWinEnter",
      "TabEnter",
      "BufWritePost",
    }, {
      pattern = "*",
      callback = function()
        outline_refresh()
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      pattern = "*",
      callback = function()
        outline_follow()
      end,
    })
  end,
  opts = {
    keymaps = {
      show_help = "?",
      close = {},
      -- Jump to symbol under cursor.
      -- It can auto close the outline window when triggered, see
      -- 'auto_close' option above.
      goto_location = "<Cr>",
      -- Jump to symbol under cursor but keep focus on outline window.
      peek_location = "o",
      -- Visit location in code and close outline immediately
      goto_and_close = {},
      -- Change cursor position of outline window to match current location in code.
      -- 'Opposite' of goto/peek_location.
      restore_location = "<C-g>",
      -- Open LSP/provider-dependent symbol hover information
      hover_symbol = "<C-space>",
      -- Preview location code of the symbol under cursor
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
      -- These fold actions are collapsing tree nodes, not code folding
      fold = {},
      unfold = {},
      fold_toggle = "<Tab>",
      -- Toggle folds for all nodes.
      -- If at least one node is folded, this action will fold all nodes.
      -- If all nodes are folded, this action will unfold all nodes.
      fold_toggle_all = "<S-Tab>",
      fold_all = {},
      unfold_all = "E",
      fold_reset = "R",
      -- Move down/up by one line and peek_location immediately.
      -- You can also use outline_window.auto_jump=true to do this for any
      -- j/k/<down>/<up>.
      down_and_jump = "<C-j>",
      up_and_jump = "<C-k>",
    },
    outline_window = {
      winhl = "Normal:NormalFloat",
    },
    outline_items = {
      auto_update_events = {
        follow = {},
        items = {},
      },
    },
    symbol_folding = {
      autofold_depth = 1,
      auto_unfold = {
        hovered = true,
      },
    },
    providers = {
      lsp = {
        blacklist_clients = {
          "copilot",
        },
      },
    },
  },
  keys = {
    {
      "<leader>fo",
      function()
        local Outline = require("outline")
        if Outline.is_open() then
          Outline.focus_outline()
        else
          Outline.open_outline()
          vim.schedule(function()
            Outline.focus_outline()
          end)
        end
      end,
      desc = "Focus outline",
    },
  },
  cmd = "Outline",
}
