---@type LazyPluginSpec
return {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 3000,
    stages = "static",
    fps = 60,
    max_height = function()
      return math.floor(
        vim.api.nvim_get_option_value("lines", { scope = "global" }) * 0.75
      )
    end,
    max_width = function()
      return math.floor(
        vim.api.nvim_get_option_value("columns", { scope = "global" }) * 0.75
      )
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  init = function()
    local notifs = {}
    local function temp(...)
      table.insert(notifs, vim.F.pack_len(...))
    end

    local orig = vim.notify
    vim.notify = temp

    local timer = vim.uv.new_timer()
    local check = vim.uv.new_check()

    local replay = function()
      timer:stop()
      check:stop()
      vim.schedule(function()
        if vim.notify == temp then
          -- try to load nvim-notify
          local succ, notify = pcall(require, "notify")
          if succ and notify ~= nil then
            vim.notify = notify
          else
            vim.notify = orig -- put back the original notify if needed
          end
        end
        vim.schedule(function()
          for _, notif in ipairs(notifs) do
            vim.notify(vim.F.unpack_len(notif))
          end
        end)
      end)
    end

    -- wait till vim.notify has been replaced
    check:start(function()
      if vim.notify ~= temp then
        replay()
      end
    end)
    -- or if it took more than 500ms, then something went wrong
    timer:start(500, 0, replay)
  end,
  config = function(_, opts)
    vim.defer_fn(function()
      require("notify").setup(opts)
    end, 30)
  end,
  keys = {
    {
      "<leader>nn",
      function()
        require("notify").dismiss { silent = true, pending = true }
      end,
      desc = "dismiss-all-notifications",
      mode = { "n", "v" },
    },
  },
}
