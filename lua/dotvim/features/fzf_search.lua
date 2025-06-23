---@module "dotvim.features.fzf_search"

local M = {}

---Find files using fzf-lua
function M.find_files()
  local cwd = vim.b._dotvim_project_cwd
  require("fzf-lua").files({
    cwd = cwd,
  })
end

---Live grep using fzf-lua
function M.live_grep()
  local cwd = vim.b._dotvim_project_cwd
  require("fzf-lua").live_grep({
    cwd = cwd,
  })
end

---Search buffers using fzf-lua
function M.buffers()
  require("fzf-lua").buffers()
end

---Search help tags using fzf-lua
function M.help_tags()
  require("fzf-lua").help_tags()
end

---Search recent files using fzf-lua
function M.oldfiles()
  require("fzf-lua").oldfiles()
end

---Search commands using fzf-lua
function M.commands()
  require("fzf-lua").commands()
end

---Search keymaps using fzf-lua
function M.keymaps()
  require("fzf-lua").keymaps()
end

---Search LSP document symbols using fzf-lua
function M.lsp_document_symbols()
  require("fzf-lua").lsp_document_symbols()
end

---Search LSP workspace symbols using fzf-lua
function M.lsp_workspace_symbols()
  require("fzf-lua").lsp_workspace_symbols()
end

---Search document diagnostics using fzf-lua
function M.diagnostics_document()
  require("fzf-lua").diagnostics_document()
end

---Search workspace diagnostics using fzf-lua
function M.diagnostics_workspace()
  require("fzf-lua").diagnostics_workspace()
end

return M
