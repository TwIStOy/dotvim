local M = {}

local T = require 'ht.utils.table'

M.tbl_keys = T.tbl_keys
M.tbl_unique = T.tbl_unique
M.tbl_slice = T.tbl_slice
M.tbl_get_value = T.table_get_value
M.list_reverse = T.list_reverse

-- replace of 'require', remove mode before loading
function M.import(modname)
  package.loaded[modname] = nil
  return require(modname)
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.delay_notify_invocations()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

-- Print deprecated message
function M.deprecated(old, new)
  local U = require 'lazy.core.util'

  U.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new),
         { title = "HT" })
end

return M
