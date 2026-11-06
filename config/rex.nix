{...}: {
  # Publish Neovim's current mode to the terminal via OSC 7501 (Program
  # Status Protocol, kept by Rex as a per-pane record). The records are
  # only ever read by Rex, so the autocmds are registered only when
  # running inside Rex ($TERM_PROGRAM is set by the terminal, like
  # iTerm/vscode do). Safe to load more than once.
  extraConfigLuaPre = ''
    if vim.env.TERM_PROGRAM == "rex" then
      local app = "nvim"
      local id = "nvim/mode"

      local MODE_NAMES = {
        n = "normal",
        no = "operator-pending",
        i = "insert",
        v = "visual", V = "visual-line", ["\22"] = "visual-block",
        s = "select", S = "select-line", ["\19"] = "select-block",
        R = "replace", Rv = "virtual-replace",
        c = "command-line", cv = "vim-ex", ce = "normal-ex",
        r = "hit-enter", rm = "more", ["r?"] = "confirm",
        ["!"] = "shell", t = "terminal",
      }

      local function emit(pairs)
        vim.api.nvim_ui_send("\27]7501;" .. pairs .. "\27\\")
      end

      local function report(mode)
        mode = mode or vim.fn.mode(1)
        local name = MODE_NAMES[mode] or MODE_NAMES[mode:sub(1, 2)] or MODE_NAMES[mode:sub(1, 1)] or mode
        -- the id says what the record is; msg carries just the value.
        emit(("state=idle:app=%s:id=%s:msg=%s"):format(app, id, vim.base64.encode(name)))
      end

      local function clear()
        emit(("state=clear:id=%s"):format(id))
      end

      local group = vim.api.nvim_create_augroup("rex_osc7501_mode", { clear = true })
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = group,
        pattern = "*",
        callback = function() report(vim.v.event.new_mode) end,
      })
      vim.api.nvim_create_autocmd("UIEnter", {
        group = group,
        once = true,
        -- no args: UIEnter would pass its autocmd event table as `mode`.
        callback = function() report() end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        callback = clear,
      })

      -- :source after startup never sees UIEnter; report where we stand now.
      if #vim.api.nvim_list_uis() > 0 then report() end
    end
  '';
}
