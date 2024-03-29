local function mkdir()
  local dir = vim.fn.expand("<afile>:p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

return function()
  ---@type dora.config
  local config = require("dora.config")

  vim.api.nvim_create_autocmd("TermEnter", {
    pattern = "*",
    callback = function()
      local winnr = vim.api.nvim_get_current_win()
      vim.api.nvim_set_option_value("nu", false, {
        scope = "local",
        win = winnr,
      })
      vim.api.nvim_set_option_value("rnu", false, {
        scope = "local",
        win = winnr,
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
    pattern = "*",
    callback = function(event)
      local lookup_table = vim.tbl_add_reverse_lookup(
        vim.deepcopy(config.vim.config.relative_number_blacklist or {})
      )

      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      local bt = vim.api.nvim_get_option_value("bt", { buf = event.buf })
      if lookup_table[ft] == nil and bt ~= "nofile" then
        local winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value("nu", true, {
          win = winnr,
        })
        vim.api.nvim_set_option_value("rnu", true, {
          win = winnr,
        })
        vim.api.nvim_set_option_value("signcolumn", "yes", {
          win = winnr,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
    pattern = "*",
    callback = function(event)
      local lookup_table = vim.tbl_add_reverse_lookup(
        vim.deepcopy(config.vim.config.relative_number_blacklist or {})
      )

      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      local bt = vim.api.nvim_get_option_value("bt", { buf = event.buf })
      if lookup_table[ft] == nil and bt ~= "nofile" then
        local winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value("nu", true, {
          win = winnr,
        })
        vim.api.nvim_set_option_value("rnu", false, {
          win = winnr,
        })
      end
    end,
  })

  -- quick close buffers with <q>
  vim.api.nvim_create_autocmd("FileType", {
    pattern = config.vim.config.quick_close_filetypes,
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.api.nvim_buf_set_keymap(
        event.buf,
        "n",
        "q",
        "<CMD>close<CR>",
        { silent = true }
      )
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    callback = function(event)
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      local lookup_table = vim.tbl_add_reverse_lookup(
        vim.deepcopy(config.vim.config.cursorline_blacklist or {})
      )
      if lookup_table[ft] == nil then
        local winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value("cursorline", true, {
          win = winnr,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    pattern = "*",
    callback = function()
      local winnr = vim.api.nvim_get_current_win()
      vim.api.nvim_set_option_value("cursorline", false, {
        win = winnr,
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
      vim.cmd("wincmd =")
      vim.cmd("tabdo wincmd =")
    end,
  })

  -- move quickfix windows to botright automatically
  vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "qf", command = "wincmd J" }
  )

  -- highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "WinClosed", "WinEnter" }, {
    pattern = "*",
    callback = function()
      -- close when all windows are uncountable
      config.vim.check_last_window()
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      mkdir()
    end,
  })
end
