local M = {}

local A = vim.api
local lsp_hover_ns = A.nvim_create_namespace("ht_lsp_hover")

function M.declaration()
  vim.lsp.buf.declaration()
end

function M.definitions()
  require("glance").open("definitions")
end

function M.type_definitions()
  require("glance").open("type_definitions")
end

function M.implementations()
  require("glance").open("implementations")
end

function M.references()
  require("glance").open("references")
end

function M.rename(new_name, options)
  options = options or {}
  local filter = function(client)
    return not vim.tbl_contains({ "null-ls", "copilot" }, client.name)
  end
  options.filter = options.filter or filter
  vim.lsp.buf.rename(new_name, options)
end

function M.code_action()
  vim.cmd("Lspsaga code_action")
end

function M.open_diagnostic()
  local opts = {
    focusable = false,
    close_events = {
      "CursorMoved",
      "InsertEnter",
      "User ShowHover",
      "BufLeave",
      "FocusLost",
    },
    border = "solid",
    source = "if_many",
    prefix = " ",
    focus = false,
    scope = "cursor",
  }
  local bufnr, win = vim.diagnostic.open_float(opts)
  vim.api.nvim_set_option_value(
    "winhl",
    "FloatBorder:NormalFloat",
    { win = win }
  )
end

function M.show_hover()
  vim.o.eventignore = "CursorHold"
  vim.cmd("doautocmd User ShowHover")
  vim.lsp.buf.hover()
  A.nvim_create_autocmd({ "CursorMoved" }, {
    group = lsp_hover_ns,
    buffer = 0,
    command = 'set eventignore=""',
    once = true,
  })
end

function M.prev_diagnostic()
  vim.diagnostic.goto_prev { wrap = false }
end

function M.next_diagnostic()
  vim.diagnostic.goto_next { wrap = false }
end

function M.prev_error_diagnostic()
  vim.diagnostic.goto_prev {
    wrap = false,
    severity = vim.diagnotic.severity.ERROR,
  }
end

function M.next_error_diagnostic()
  vim.diagnostic.goto_next {
    wrap = false,
    severity = vim.diagnotic.severity.ERROR,
  }
end

function M.client_capabilities()
  local cmp_lsp = require("cmp_nvim_lsp")
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = cmp_lsp.default_capabilities(default_capabilities)
  return capabilities
end

function M.buf_formattable(bufnr)
  local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local generators = require("null-ls.generators")
  local methods = require("null-ls.methods")
  local available_generators =
    generators.get_available(file_type, methods.internal.FORMATTING)
  return #available_generators > 0
end

function M.format(bufnr)
  if not M.buf_formattable(bufnr) then
    vim.notify("Current buffer is not formattable", vim.log.levels.WARN)
    return
  end
  vim.lsp.buf.format {
    filter = function(c)
      return c.name == "null-ls"
    end,
  }
end

function M.progress()
  local spinners =
    { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
  local ms = vim.uv.hrtime() / 1000000
  local spinner = spinners[(math.floor(ms / 120) % #spinners) + 1]

  local active_clients = vim.lsp.get_clients {
    bufnr = 0,
  }
  local percentage = nil
  local groups = {}
  for _, client in ipairs(active_clients) do
    for progress in client.progress do
      local value = progress.value

      if type(value) == "table" and value.kind then
        local group = groups[progress.token]
        if not group then
          group = {}
          groups[progress.token] = group
        end
        group.title = value.title or group.title
        group.message = value.message or group.message
        if value.percentage then
          percentage = math.max(percentage or 0, value.percentage)
        end
      end
    end
  end

  local messages = {}
  for _, group in pairs(groups) do
    if group.title then
      table.insert(
        messages,
        group.message and (group.title .. ": " .. group.message) or group.title
      )
    elseif group.message then
      table.insert(messages, group.message)
    end
  end
  local message = table.concat(messages, ", ")
  if percentage then
    return string.format("%%<%s %03d%%%%: %s", spinner, percentage, message)
  end
  if #message > 0 then
    return string.format("%%<%s %s", spinner, message)
  end
  return message
end

---@param bufnr number
function M.setup_inlay_hints(bufnr)
  vim.api.nvim_create_autocmd(
    { "BufEnter", "InsertLeave", "BufWinEnter", "BufWritePost" },
    {
      buffer = bufnr,
      callback = function()
        vim.lsp._inlay_hint.refresh()
      end,
    }
  )
end

local symbol_funcs = require("ht.with_plug.lsp.symbols")
M = vim.tbl_extend("error", M, symbol_funcs)

return M
