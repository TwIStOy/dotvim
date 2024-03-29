---@type dora.core.plugin.PluginOption[]
return {
  {
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

        ---@type dora.core.registry
        local registry = require("dora.core.registry")

        if registry.has("telescope.nvim") then
          require("telescope").load_extension("notify")
        end
      end, 30)
    end,
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "nvim-notify",
        category = "Notify",
        actions = {
          {
            id = "notify.list-history",
            title = "List notify histories using telescope",
            callback = function()
              require("telescope").extensions.notify.notify()
            end,
            keys = { "<leader>lh", desc = "list-history" },
          },
          {
            id = "notify.dismiss-all",
            title = "Dismiss all notifications",
            callback = function()
              require("notify").dismiss { silent = true, pending = true }
            end,
            keys = { "<leader>nn", desc = "dismiss-all" },
          },
        },
      }
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        title_pos = "center",
        relative = "editor",
        insert_only = true,
        start_in_insert = true,
      },
    },
    init = function()
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "WinNew",
    opts = {
      create_event = function()
        local winCount =
          require("colorful-winsep.utils").calculate_number_windows()
        if winCount == 2 then
          local leftWinId = vim.fn.win_getid(vim.fn.winnr("h"))
          local filetype = vim.api.nvim_get_option_value(
            "filetype",
            { buf = vim.api.nvim_win_get_buf(leftWinId) }
          )
          if filetype == "NvimTree" or filetype == "neo-tree" then
            require("colorful-winsep").NvimSeparatorDel()
          end
        end
      end,
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    opts = {
      filter_rules = {
        bo = {
          filetype = { "NvimTree", "neo-tree", "notify", "NvimSeparator", "" },
          buftype = { "terminal" },
        },
      },
    },
  },
}
