---@module "dotvim.features.snacks_picker"
local M = {}

---Find files using snacks.picker
function M.find_files()
  local cwd = vim.b._dotvim_project_cwd
  require("snacks").picker.files({
    cwd = cwd,
  })
end

---Live grep using snacks.picker
function M.live_grep()
  local cwd = vim.b._dotvim_project_cwd
  require("snacks").picker.grep({
    cwd = cwd,
  })
end

---Search buffers using snacks.picker
function M.buffers()
  require("snacks").picker.buffers()
end

---Search help tags using snacks.picker
function M.help_tags()
  require("snacks").picker.help()
end

---Search recent files using snacks.picker
function M.oldfiles()
  require("snacks").picker.recent()
end

---Search commands using snacks.picker
function M.commands()
  require("snacks").picker.commands()
end

---Search keymaps using snacks.picker
function M.keymaps()
  require("snacks").picker.keymaps()
end

---Search LSP document symbols using snacks.picker
function M.lsp_document_symbols()
  require("snacks").picker.lsp_symbols()
end

---Search LSP workspace symbols using snacks.picker
function M.lsp_workspace_symbols()
  require("snacks").picker.lsp_workspace_symbols()
end

---Search LSP workspace symbols for word under cursor
function M.lsp_workspace_symbols_cword()
  local cword = vim.fn.expand("<cword>")
  require("snacks").picker.lsp_workspace_symbols({
    search = cword,
  })
end

---Search document diagnostics using snacks.picker
function M.diagnostics_document()
  require("snacks").picker.diagnostics_buffer()
end

---Search workspace diagnostics using snacks.picker
function M.diagnostics_workspace()
  require("snacks").picker.diagnostics()
end

return M
