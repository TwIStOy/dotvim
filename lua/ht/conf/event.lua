local relative_number_blacklist = {
  ["startify"] = true,
  ["NvimTree"] = true,
  ["packer"] = true,
  ["alpha"] = true,
  ["nuipopup"] = true,
  ["toggleterm"] = true,
  ["noice"] = true,
  ["crates.nvim"] = true,
  ["lazy"] = true,
  ["Trouble"] = true,
  ["rightclickpopup"] = true,
  ["TelescopePrompt"] = true,
  ["Glance"] = true,
  ["DressingInput"] = true,
  ["lspinfo"] = true,
  ["nofile"] = true,
  ["mason"] = true,
  ["Outline"] = true,
  ["aerial"] = true,
  ["flutterToolsOutline"] = true,
  [""] = true,
}

local cursorline_blacklist = {
  ["alpha"] = true,
  ["noice"] = true,
}

local quick_close_filetypes = {
  "qf",
  "help",
  "man",
  "notify",
  "nofile",
  "lspinfo",
  "terminal",
  "prompt",
  "toggleterm",
  "copilot",
  "startuptime",
  "tsplayground",
  "PlenaryTestPopup",
  "aerial",
  "Outline",
}

local function mkdir()
  local dir = vim.fn.expand("<afile>:p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function setup()
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
    ---@param event vim.AutocmdCallback.Event
    callback = function(event)
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      if relative_number_blacklist[ft] == nil then
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
    ---@param event vim.AutocmdCallback.Event
    callback = function(event)
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      if relative_number_blacklist[ft] == nil then
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
    pattern = quick_close_filetypes,
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
    ---@param event vim.AutocmdCallback.Event
    callback = function(event)
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      if cursorline_blacklist[ft] == nil then
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

  vim.api.nvim_create_autocmd({ "BufEnter", "WinClosed" }, {
    pattern = "*",
    callback = function()
      require("ht.core.window").check_last_window()
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      mkdir()
    end,
  })
end

return {
  setup = setup,
}
