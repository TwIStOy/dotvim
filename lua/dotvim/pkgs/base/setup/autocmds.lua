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
  ["neo-tree"] = true,
  ["neo-tree-popup"] = true,
  ["fzf"] = true,
  ["neotest-summary"] = true,
  ["neotest-output"] = true,
  [""] = true,
}

local cursorline_blacklist = {
  ["alpha"] = true,
  ["noice"] = true,
  ["mason"] = true,
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
  "ClangdAST",
  "neotest-summary",
  "neotest-output",
  "spectre_panel",
}

local Shared = require("dotvim.pkgs.base.setup.shared")

local function mkdir()
  local dir = vim.fn.expand("<afile>:p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

return function()
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
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      local bt = vim.api.nvim_get_option_value("bt", { buf = event.buf })
      if relative_number_blacklist[ft] == nil and bt ~= "nofile" then
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
      local ft = vim.api.nvim_get_option_value("ft", { buf = event.buf })
      local bt = vim.api.nvim_get_option_value("bt", { buf = event.buf })
      if relative_number_blacklist[ft] == nil and bt ~= "nofile" then
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

  -- special case for `neo-tree`
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "neo-tree",
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      local buf = event.buf
      vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "", {
        noremap = true,
        callback = function()
          vim.api.nvim_win_close(0, true)
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end,
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
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

  vim.api.nvim_create_autocmd({ "BufEnter", "WinClosed", "WinEnter" }, {
    pattern = "*",
    callback = function()
      -- close when all windows are uncountable
      Shared.check_last_window()
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      mkdir()
    end,
  })
end
