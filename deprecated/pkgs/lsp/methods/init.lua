local Methods = {}

function Methods.declaration()
  -- vscode-neovim provides builtin vim.lsp.buf overrides
  vim.lsp.buf.declaration()
end

function Methods.definitions()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.definition()
  else
    require("glance").open("definitions")
  end
end

function Methods.type_definitions()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.type_definition()
  else
    require("glance").open("type_definitions")
  end
end

function Methods.implementations()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.implementation()
  else
    require("glance").open("implementations")
  end
end

function Methods.references()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.references()
  else
    require("glance").open("references")
  end
end

function Methods.code_action()
  -- vscode-neovim provides builtin vim.lsp.buf overrides
  vim.lsp.buf.code_action()
end

function Methods.next_diagnostic()
  if vim.g.vscode then
    require("vscode").call("editor.action.marker.nextInFiles")
  else
    vim.diagnostic.goto_next { wrap = false, float = false }
  end
end

function Methods.prev_diagnostic()
  if vim.g.vscode then
    require("vscode").call("editor.action.marker.prevInFiles")
  else
    vim.diagnostic.goto_prev { wrap = false, float = false }
  end
end

local lsp_hover_group =
  vim.api.nvim_create_augroup("dtovim_lsp_hover", { clear = true })

function Methods.show_hover()
  if vim.g.vscode then
    -- vscode-neovim provides builtin vim.lsp.buf overrides
    vim.lsp.buf.hover()
  else
    vim.o.eventignore = "CursorHold"
    vim.api.nvim_exec_autocmds("User", {
      pattern = "DotvimShowHover",
    })
    vim.lsp.buf.hover()
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = lsp_hover_group,
      buffer = 0,
      command = 'set eventignore=""',
      once = true,
    })
  end
end

local function close_preview_window(winnr, bufnrs)
  vim.schedule(function()
    -- exit if we are in one of ignored buffers
    if bufnrs and vim.list_contains(bufnrs, vim.api.nvim_get_current_buf()) then
      return
    end

    local augroup = "preview_window_" .. winnr
    pcall(vim.api.nvim_del_augroup_by_name, augroup)
    pcall(vim.api.nvim_win_close, winnr, true)
  end)
end

local function close_preview_autocmd(events, winnr, bufnrs)
  local augroup = vim.api.nvim_create_augroup("preview_window_" .. winnr, {
    clear = true,
  })

  -- close the preview window when entered a buffer that is not
  -- the floating window buffer or the buffer that spawned it
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      close_preview_window(winnr, bufnrs)
    end,
  })

  if #events > 0 then
    local simple_events = {}
    local events_with_pattern = {}

    for _, event in ipairs(events) do
      -- split event with space
      local parts = vim.split(event, " ", {
        trimempty = false,
      })
      if #parts == 1 then
        table.insert(simple_events, event)
      else
        local pattern = table.concat({ unpack(parts, 2) }, " ")
        table.insert(events_with_pattern, {
          event = parts[1],
          pattern = pattern,
        })
      end
    end

    vim.api.nvim_create_autocmd(simple_events, {
      group = augroup,
      buffer = bufnrs[2],
      callback = function()
        close_preview_window(winnr)
      end,
    })
    for _, event in ipairs(events_with_pattern) do
      vim.api.nvim_create_autocmd(event.event, {
        group = augroup,
        buffer = bufnrs[2],
        callback = function(ev)
          if ev.match == event.pattern then
            close_preview_window(winnr)
          end
        end,
      })
    end
  end
end

local function open_builtin_diagnostic()
  local opts = {
    focusable = false,
    border = "solid",
    source = "if_many",
    prefix = " ",
    focus = false,
    scope = "cursor",
  }

  local bufnr, win = vim.diagnostic.open_float(opts)

  if bufnr == nil then
    return
  end

  vim.api.nvim_set_option_value(
    "winhl",
    "FloatBorder:NormalFloat,Normal:NormalFloat",
    { win = win }
  )

  close_preview_autocmd({
    "CursorMoved",
    "InsertEnter",
    "User DotvimShowHover",
    "BufLeave",
    "FocusLost",
  }, win, { bufnr, vim.api.nvim_get_current_buf() })
end

function Methods.open_diagnostic()
  open_builtin_diagnostic()
  -- require("corn").render()
end

function Methods.rename(new_name, options)
  options = options or {}
  local filter = function(client)
    return not vim.tbl_contains({ "null-ls", "copilot" }, client.name)
  end
  options.filter = options.filter or filter
  vim.lsp.buf.rename(new_name, options)
end

function Methods.organize_imports()
  vim.lsp.buf.code_action {
    context = { only = { "source.organizeImports" } },
    apply = true,
  }
end

return Methods
