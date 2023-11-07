---@param winnr number?
---@return { [1]: number, [2]: number }
local function get_cursor_0index(winnr)
  winnr = winnr or 0
  local c = vim.api.nvim_win_get_cursor(winnr)
  c[1] = c[1] - 1
  return c
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

local function is_nil(v)
  return v == nil or v == vim.NIL
end

---@param ... any
---@return any
local function if_nil(...)
  local nargs = select('#', ...)
  for i = 1, nargs do
    local v = select(i, ...)
    if not is_nil(v) then
      return v
    end
  end
  return nil
end

return {
  get_cursor_0index = get_cursor_0index,
  close_preview_autocmd = close_preview_autocmd,
  is_nil = is_nil,
  if_nil = if_nil,
}
