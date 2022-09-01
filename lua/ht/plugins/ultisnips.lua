local M = {}

M.core = {
  'TwIStOy/ultisnips',
  ft = { 'cpp', 'c', 'markdown', 'vimwiki', 'rust', 'go', 'python', 'snippet' },
  event = 'InsertEnter',
}

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  vim.cmd [[py3 from snippet_tools.cpp import register_postfix_snippets]]
  vim.cmd [[py3 register_postfix_snippets()]]
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

