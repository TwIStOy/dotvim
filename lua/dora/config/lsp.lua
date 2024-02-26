---@class dora.config.lsp.BackendConfig
---@field definitions 'native' | 'telescope' | 'glance'

local M = {}

function M.declaration()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.revealDeclaration")
  else
    vim.lsp.buf.declaration()
  end
end

function M.definitions()
  local config = require("dora.config").config
  local backend = config.lsp.definitions or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.revealDefinition")
  elseif backend == "native" then
    vim.lsp.buf.definition()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_definitions()
  elseif backend == "glance" then
    require("glance").open("definitions")
  else
    vim.notify(
      "Unknown backend for definitions: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

function M.type_definitions()
  local config = require("dora.config").config
  local backend = config.lsp.type_definitions or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.goToTypeDefinition")
  elseif backend == "native" then
    vim.lsp.buf.type_definition()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_type_definitions()
  elseif backend == "glance" then
    require("glance").open("type_definitions")
  else
    vim.notify(
      "Unknown backend for type definitions: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

function M.implementations()
  local config = require("dora.config").config
  local backend = config.lsp.implementations or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.goToImplementation")
  elseif backend == "native" then
    vim.lsp.buf.implementation()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_implementations()
  elseif backend == "glance" then
    require("glance").open("implementations")
  else
    vim.notify(
      "Unknown backend for implementations: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

function M.references()
  local config = require("dora.config").config
  local backend = config.lsp.implementations or "native"
  if vim.g.vscode then
    require("vscode-neovim").call("references-view.findReferences")
  elseif backend == "native" then
    vim.lsp.buf.references()
  elseif backend == "telescope" then
    require("telescope.builtin").lsp_references()
  elseif backend == "glance" then
    require("glance").open("references")
  else
    vim.notify(
      "Unknown backend for references: " .. backend,
      vim.log.levels.ERROR
    )
  end
end

function M.code_action()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.quickFix")
  else
    vim.cmd("Lspsaga code_action")
  end
end

function M.next_diagnostic()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.marker.nextInFiles")
  else
    vim.lsp.diagnostic.goto_next()
  end
end

function M.prev_diagnostic()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.marker.prevInFiles")
  else
    vim.lsp.diagnostic.goto_prev()
  end
end

local lsp_hover_group =
  vim.api.nvim_create_augroup("dora_lsp_hover", { clear = true })

function M.show_hover()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.showHover")
  else
    vim.o.eventignore = "CursorHold"
    vim.api.nvim_exec_autocmds("User", {
      pattern = "ShowHover",
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

function M.open_diagnostic()
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
    "User ShowHover",
    "BufLeave",
    "FocusLost",
  }, win, { bufnr, vim.api.nvim_get_current_buf() })
end

return M
