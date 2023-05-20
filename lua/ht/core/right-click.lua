local M = {}

M.indexes = {
  -- shortcuts, 0-10
  textobject = 1,

  -- languages
  lsp = 30,
  rust_tools = 40,
  clangd = 40,
  crates = 41,
  cpp_toolkit = 41,

  -- tools
  copilot = 50,

  -- others, 90
  splitline = 99,
  file_explorer = 100,
}

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
