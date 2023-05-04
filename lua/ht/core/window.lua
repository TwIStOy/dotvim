local M = {}

local vcall = vim.api.nvim_call_function
local cmd = vim.api.nvim_command
local A = vim.api

--[[
uncountable filetypes and buftypes will be ignored when windows counting and
will not block vim quiting.
--]]
local uncountable_types = {
  quickfix = true,
  defx = true,
  CHADTree = true,
  NvimTree = true,
  noice = true,
  fidget = true,
  scrollview = true,
  notify = true,
  Trouble = true,
  sagacodeaction = true,
}

function M.skip_filetype(ft)
  uncountable_types[ft] = true
end

local function is_uncountable(win_id)
  local buf_id = A.nvim_win_get_buf(win_id)
  local ft = A.nvim_buf_get_option(buf_id, "ft")
  local bt = A.nvim_buf_get_option(buf_id, "buftype")

  return (uncountable_types[ft] ~= nil and uncountable_types[ft])
    or (uncountable_types[bt] ~= nil and uncountable_types[bt])
end

--[[
Goto `count` window from left to right, up to bottom. Skip all `uncountable`
filetypes and buftypes.
--]]
function M.goto_window(count)
  local function skip_uncountable_windows(cnt)
    local rest = cnt

    for _, win_id in pairs(vim.api.nvim_list_wins()) do
      if not is_uncountable(win_id) then
        rest = rest - 1
        if rest == 0 then
          return win_id
        end
      end
    end

    return 0
  end

  local win_id = skip_uncountable_windows(count)
  if win_id > 0 then
    vim.api.nvim_set_current_win(win_id)
  end
end

local function quickfix_window_exists()
  local n = vcall("winnr", { "$" })
  for i = 1, n do
    local win_id = vcall("win_getid", { i })
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = A.nvim_buf_get_option(buf_id, "buftype")

    if tp == "quickfix" then
      return true
    end
  end

  return false
end

function M.toggle_quickfix()
  if quickfix_window_exists() then
    cmd("cclose")
  else
    cmd("copen")
  end
end

function M.check_last_window()
  local n = vcall("winnr", { "$" })
  local total = n
  for i = 1, n do
    local win_id = vcall("win_getid", { i })
    if is_uncountable(win_id) then
      total = total - 1
    end
  end

  if total == 0 then
    if vim.api.nvim_call_function("tabpagenr", { "$" }) == 1 then
      cmd([[quitall!]])
    else
      cmd([[tabclose]])
    end
  end
end

return M
-- vim: et sw=2 ts=2
