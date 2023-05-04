local M = {}

M.add_section = function(opts)
  local db = require("right-click.database")
  if M.default == nil then
    M.default = db.new_db()
  end
  M.default:add_section(opts)
end

M.show = function()
  if M.default ~= nil then
    M.default:show()
  end
end

return M
