module('ht.plugs.template', package.seeall)

function setup()
  vim.g.templates_directory = {os.getenv('HOME') .. [[/.dotvim/vim-templates]]}
  vim.g.templates_no_autocmd = 0
  vim.g.templates_debug = 0
  vim.g.templates_no_builtin_templates = 1
end

-- vim: et sw=2 ts=2

