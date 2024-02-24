local function jump2word(forward)
  require("flash").jump {
    pattern = ".", -- initialize pattern with any char
    search = {
      forward = forward,
      multi_window = false,
      wrap = false,
      mode = function(str)
        return "\\<" .. str
      end,
    },
    label = {
      after = false,
      before = { 0, 0 },
      uppercase = false,
      format = function(opts)
        return {
          { opts.match.label1, "FlashMatch" },
          { opts.match.label2, "FlashLabel" },
        }
      end,
    },
    action = function(match, state)
      state:hide()
      require("flash").jump {
        search = { max_length = 0 },
        highlight = { matches = false },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          vim.print(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      }
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  }
end

---@type dora.lib.PluginOptions
return {
  "folke/flash.nvim",
  keys = {
    {
      "s",
      mode = { "n", "o", "x" },
      function()
        require("flash").jump()
      end,
      desc = "flash",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "remote-flash",
    },
    {
      "<leader>rd",
      mode = "n",
      function()
        require("flash").jump {
          matcher = function(win)
            return vim.tbl_map(function(diag)
              return {
                pos = { diag.lnum + 1, diag.col },
                end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
              }
            end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
          end,
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              require("ht.with_plug.lsp").open_diagnostic()
            end)
            state:restore()
          end,
        }
      end,
      desc = "show-diagnostic-at-target",
    },
    {
      "f",
      mode = "n",
      function()
        jump2word(true)
      end,
    },
    {
      "F",
      mode = "n",
      function()
        jump2word(false)
      end,
    },
  },
  config = true,
  opts = {
    labels = "etovxqpdygfblzhckisuran",
    label = {
      uppercase = false,
      rainbow = {
        enable = true,
      },
    },
    jump = {
      autojump = true,
    },
    modes = {
      char = {
        enabled = true,
        keys = {},
      },
      search = {
        enabled = false,
      },
    },
    remote_op = {
      restore = true,
      motion = true,
    },
  },
  gui = "all",
}
