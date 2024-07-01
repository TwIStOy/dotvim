---@type dotvim.utils.string
local String = require("dotvim.utils.string")
---@type dotvim.utils.vim
local Vim = require("dotvim.utils.vim")
---@type dotvim.utils.fn
local Fn = require("dotvim.utils.fn")

local MAX_ALLOWED_LINES = 20
local LEFT_SEPARATOR = ""
local RIGHT_SEPARATOR = ""

local DIAGNOSTIC_HEADER_SIGN = "●"
local DIAGNOSTIC_BODY_SIGN = "│"
local DIAGNOSTIC_BODY_END_SIGN = "└"

local function severity_to_hl_group(severity)
  if severity == vim.lsp.protocol.DiagnosticSeverity.Error then
    return "DotvimInlineDiagError"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
    return "DotvimInlineDiagWarn"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Information then
    return "DotvimInlineDiagInfo"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
    return "DotvimInlineDiagHint"
  end
end

local function severity_to_inv_hl_group(severity)
  if severity == vim.lsp.protocol.DiagnosticSeverity.Error then
    return "DotvimInvInlineDiagError"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
    return "DotvimInvInlineDiagWarn"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Information then
    return "DotvimInvInlineDiagInfo"
  elseif severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
    return "DotvimInvInlineDiagHint"
  end
end

---@param diagnostics vim.Diagnostic[]
local function get_current_pos_diags(diagnostics, curline, curcol)
  local current_pos_diags = {}

  for _, diag in ipairs(diagnostics) do
    if
      diag.lnum == curline
      and curcol >= diag.col
      and curcol <= diag.end_col
    then
      table.insert(current_pos_diags, diag)
    end
  end

  if next(current_pos_diags) == nil then
    if #diagnostics == 0 then
      return current_pos_diags
    end
    table.insert(current_pos_diags, diagnostics[1])
  end

  return current_pos_diags
end

--- @param chunks string[]
--- @return number
local function get_max_width_from_chunks(chunks)
  local max_chunk_line_length = 0

  for _, chunk in ipairs(chunks) do
    if #chunk > max_chunk_line_length then
      max_chunk_line_length = #chunk
    end
  end

  return max_chunk_line_length
end

---@param win number
---@return vim.Diagnostic[]
local function get_diagnostic_under_cursor(win)
  local cursor_pos = vim.api.nvim_win_get_cursor(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  local curline = cursor_pos[1] - 1

  ---@type vim.Diagnostic[]
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = curline })
  return diagnostics
end

---@param win number
local function get_current_line_remain_col(win)
  local cursor_pos = vim.api.nvim_win_get_cursor(win)
  local curline = cursor_pos[1] - 1
  local line = vim.api.nvim_buf_get_lines(0, curline, curline + 1, true)[1]
  -- window width
  local width = vim.api.nvim_win_get_width(win)
  return width - #line - 18
end

---@param msg string
---@param max_width number
---@param remaining integer
---@return string[]
local function break_diag_msg_into_lines(msg, max_width, remaining)
  local lines, truncated = String.wrap_text(msg, max_width, remaining)
  if truncated then
    lines[#lines + 1] = "..."
  end
  local ret = {}
  for i, line in ipairs(lines) do
    if i == 1 then
      ret[i] = DIAGNOSTIC_HEADER_SIGN .. " " .. line
    elseif i == #lines then
      ret[i] = DIAGNOSTIC_BODY_END_SIGN .. " " .. line
    else
      ret[i] = DIAGNOSTIC_BODY_SIGN .. " " .. line
    end
  end
  return ret
end

---@param lines string[]
---@param remaining integer remaining lines at lease one line
---@return string[]
local function truncate_lines_and_add_signs(lines, remaining)
  local ret = {}

  if remaining == 1 then
    ret[1] = DIAGNOSTIC_HEADER_SIGN .. " " .. lines[1]
    return ret
  end

  for i, line in ipairs(lines) do
    if i == 1 then
      ret[i] = DIAGNOSTIC_HEADER_SIGN .. " " .. line
    elseif i == remaining then
      if i == #lines then
        ret[i] = DIAGNOSTIC_BODY_END_SIGN .. " " .. line
      else
        ret[i] = DIAGNOSTIC_BODY_END_SIGN .. " ..."
      end
      break
    elseif i == #lines then
      ret[i] = DIAGNOSTIC_BODY_END_SIGN .. " " .. line
    else
      ret[i] = DIAGNOSTIC_BODY_SIGN .. " " .. line
    end
  end

  return ret
end

---@param diagnostics vim.Diagnostic[]
---@param max_width number
---@return {[1]:string, [2]:string}[]
local function build_diagnostic_lines(diagnostics, max_width)
  local ret = {}
  local diagnostics_wrapped_lines = {}
  for _, diag in ipairs(diagnostics) do
    diagnostics_wrapped_lines[#diagnostics_wrapped_lines + 1] =
      String.wrap_text(diag.message, max_width, MAX_ALLOWED_LINES)
  end

  -- Make sure each diagnostic message has at least one line.
  -- If there are remaining lines, try to add more lines in order.
  local remaining = MAX_ALLOWED_LINES - #diagnostics
  for i, lines in ipairs(diagnostics_wrapped_lines) do
    local truncated = truncate_lines_and_add_signs(lines, remaining)
    local hl = severity_to_hl_group(diagnostics[i].severity)
    for _, line in ipairs(truncated) do
      ret[#ret + 1] = { { line, hl } }
    end
    remaining = remaining - #truncated
  end

  local inv_hl = severity_to_inv_hl_group(diagnostics[1].severity)
  local hl = severity_to_hl_group(diagnostics[1].severity)

  if #ret == 1 then
    local raw = ret[1]
    local replaced = {
      { LEFT_SEPARATOR, inv_hl },
    }
    vim.list_extend(replaced, raw)
    replaced[#replaced + 1] = { RIGHT_SEPARATOR, inv_hl }

    ret[1] = replaced
  else
    for i, raw in ipairs(ret) do
      local replaced = {
        { " ", hl },
      }
      vim.list_extend(replaced, raw)
      replaced[#replaced + 1] = { " ", hl }

      ret[i] = replaced
    end
  end

  return ret
end

local M = {}

---@return {[1]:string, [2]:string}[]?
function M.get_current_line_diag_virt_lines()
  local win = vim.api.nvim_get_current_win()
  local diagnostics = get_diagnostic_under_cursor(win)
  if #diagnostics == 0 then
    return nil
  end
  local max_width = get_current_line_remain_col(win)
  local lines = build_diagnostic_lines(diagnostics, max_width)
  return lines
end

local inline_diag_namespace =
  vim.api.nvim_create_namespace("dotvim_inline_diag")
local inline_diag_extmark_id = nil

local rendering_win = nil
local rendering_line = nil

local setup_highlights = Fn.invoke_once(function()
  local colors = {
    Error = Vim.resolve_color("DiagnosticError"),
    Warn = Vim.resolve_color("DiagnosticWarn"),
    Info = Vim.resolve_color("DiagnosticInfo"),
    Hint = Vim.resolve_color("DiagnosticHint"),
  }
  local background = Vim.resolve_bg("CursorLine")
  local blends = {
    Error = Vim.blend(colors.Error.fg, "#000000", 0.27),
    Warn = Vim.blend(colors.Warn.fg, "#000000", 0.27),
    Info = Vim.blend(colors.Info.fg, "#000000", 0.27),
    Hint = Vim.blend(colors.Hint.fg, "#000000", 0.27),
  }

  for severity, color in pairs(colors) do
    vim.api.nvim_set_hl(0, "DotvimInlineDiag" .. severity, {
      bg = blends[severity],
      fg = color.fg,
    })
    vim.api.nvim_set_hl(0, "DotvimInvInlineDiag" .. severity, {
      fg = blends[severity],
      bg = background,
    })
  end

  return nil
end)

M.render_inline_diagnostic = function()
  setup_highlights()

  local win = vim.api.nvim_get_current_win()
  local curline = vim.api.nvim_win_get_cursor(win)[1] - 1
  local buffer = vim.api.nvim_win_get_buf(win)
  if rendering_win == win and rendering_line == curline then
    return
  end
  if inline_diag_extmark_id ~= nil then
    -- clear current rendering
    vim.api.nvim_buf_del_extmark(
      buffer,
      inline_diag_namespace,
      inline_diag_extmark_id
    )
    inline_diag_extmark_id = nil
    rendering_win = nil
    rendering_line = nil
  end

  local virt_lines = M.get_current_line_diag_virt_lines()
  if virt_lines == nil then
    return
  end

  local first_line = virt_lines[1]
  -- local other_lines = { unpack(virt_lines, 2) }
  local line = vim.api.nvim_buf_get_lines(0, curline, curline + 1, true)[1]
  local other_lines = {}
  for i = 2, #virt_lines do
    other_lines[#other_lines + 1] = {
      { string.rep(" ", #line + 1), 'CursorLine' },
      unpack(virt_lines[i]),
    }
  end
  vim.print(other_lines)

  inline_diag_extmark_id =
    vim.api.nvim_buf_set_extmark(buffer, inline_diag_namespace, curline, 0, {
      id = curline + 1,
      line_hl_group = "CursorLine",
      virt_text = first_line,
      virt_lines = other_lines,
      priority = 1,
    })
  rendering_win = win
  rendering_line = curline
end

return M
