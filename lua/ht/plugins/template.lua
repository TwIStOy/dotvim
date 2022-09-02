local M = {}

M.core = { 'aperezdc/vim-template', cmd = { 'Template', 'TemplateHere' } }

M.setup = function() -- code to run before plugin loaded
  vim.g.templates_directory =
      { os.getenv('HOME') .. [[/.dotvim/vim-templates]] }
  vim.g.templates_no_autocmd = 0
  vim.g.templates_debug = 0
  vim.g.templates_no_builtin_templates = 1
end

M.config = function() -- code to run after plugin loaded
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

