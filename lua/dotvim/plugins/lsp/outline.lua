local Commons = require("dotvim.commons")

---@type LazyPluginSpec
return {
  "hedyhli/outline.nvim",
  cmd = "Outline",
  keys = {
    {
      "<leader>fo",
      function()
        local Outline = require("outline")
        ---@diagnostic disable-next-line: undefined-field
        if Outline.is_open() then
          ---@diagnostic disable-next-line: undefined-field
          Outline.focus_outline()
        else
          ---@diagnostic disable-next-line: undefined-field
          Outline.open_outline()
          ---@diagnostic disable-next-line: undefined-global
          vim.schedule(function()
            ---@diagnostic disable-next-line: undefined-field
            Outline.focus_outline()
          end)
        end
      end,
      desc = "focus-outline",
    },
  },
  config = function(_, opts)
    local Outline = require("outline")
    ---@diagnostic disable-next-line: undefined-field
    Outline.setup(opts)

    local outline_follow = Commons.fn.throttle(2000, function()
      ---@diagnostic disable-next-line: undefined-field
      Outline.follow_cursor {
        focus_outline = false,
      }
    end)

    local outline_refresh = Commons.fn.throttle(2000, function()
      ---@diagnostic disable-next-line: undefined-field
      Outline.refresh()
    end)

    ---@diagnostic disable-next-line: undefined-global
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

    ---@diagnostic disable-next-line: undefined-global
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
      goto_location = "<Cr>",
      peek_location = "o",
      goto_and_close = {},
      restore_location = "<C-g>",
      hover_symbol = "<C-space>",
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
      fold = {},
      unfold = {},
      fold_toggle = "<Tab>",
      fold_toggle_all = "<S-Tab>",
      fold_all = {},
      unfold_all = "E",
      fold_reset = "R",
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
}
