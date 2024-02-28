---@class dora.config.lsp
local M = {}

---@type dora.config.lsp.Config
M.config = {}

---@class dora.config.lsp.SetupOptions
---@field config? dora.config.lsp.Config
---@field methods? dora.config.lsp.methods

---@param opts dora.config.lsp.SetupOptions
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts.config or {}) --[[@as dora.config.lsp.Config]]
  M.methods = vim.tbl_extend("force", M.methods, opts.methods or {}) --[[@as dora.config.lsp.methods]]
end

---@alias dora.config.lsp.config.Backend "native" | "telescope" | "glance" | "lspsaga"

---@class dora.config.lsp.config.BackendOptions
---@field ["*"] dora.config.lsp.config.Backend|nil
---@field definitions? dora.config.lsp.config.Backend
---@field type_definitions? dora.config.lsp.config.Backend
---@field implementations? dora.config.lsp.config.Backend
---@field references? dora.config.lsp.config.Backend
---@field code_action? dora.config.lsp.config.Backend

---@class dora.config.lsp.Config
---@field backend? dora.config.lsp.config.BackendOptions
---@field server_opts? table<string, table>
---@field capabilities? table
---@field setups? table<string, function>

---@type dora.config.lsp.Config
local Config = {
  backend = {
    ["*"] = "native",
    definitions = "glance",
    type_definitions = "glance",
    implementations = "glance",
    references = "glance",
    code_action = "lspsaga",
  },
  server_opts = {},
  setups = {},
}
M.config = Config

---@class dora.config.lsp.methods
local Methods = {}
M.methods = Methods

function Methods.declaration()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.revealDeclaration")
  else
    vim.lsp.buf.declaration()
  end
end

---@param method string
---@return dora.config.lsp.config.Backend
local function get_backend(method)
  ---@type dora.lib
  local lib = require("dora.lib")
  return vim.F.if_nil(
    lib.tbl.optional_field(M.config, "backend", method),
    lib.tbl.optional_field(M.config, "backend", "*"),
    "native"
  )
end

function Methods.definitions()
  local backend = get_backend("definitions")
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

function Methods.type_definitions()
  local backend = get_backend("type_definitions")
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

function Methods.implementations()
  local backend = get_backend("implementations")
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

function Methods.references()
  local backend = get_backend("references")
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

function Methods.code_action()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.quickFix")
  else
    vim.cmd("Lspsaga code_action")
  end
end

function Methods.next_diagnostic()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.marker.nextInFiles")
  else
    vim.diagnostic.goto_next { wrap = false }
  end
end

function Methods.prev_diagnostic()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.marker.prevInFiles")
  else
    vim.diagnostic.goto_prev { wrap = false }
  end
end

local lsp_hover_group =
  
vim.api.nvim_create_augroup("dora_lsp_hover", { clear = true })

function Methods.show_hover()
  if vim.g.vscode then
    require("vscode-neovim").call("editor.action.showHover")
  else
    vim.o.eventignore = "CursorHold"
    vim.api.nvim_exec_autocmds("User", {
      pattern = "DoraShowHover",
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

function Methods.open_diagnostic()
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
    "User DoraShowHover",
    "BufLeave",
    "FocusLost",
  }, win, { bufnr, vim.api.nvim_get_current_buf() })
end

function Methods.rename(new_name, options)
  options = options or {}
  local filter = function(client)
    return not vim.tbl_contains({ "null-ls", "copilot" }, client.name)
  end
  options.filter = options.filter or filter
  vim.lsp.buf.rename(new_name, options)
end

return M
