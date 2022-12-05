local M = {}

M.core = {
  'TwIStOy/ultisnips',
  -- ft = { 'cpp', 'c', 'markdown', 'vimwiki', 'rust', 'go', 'python', 'snippet' },
  opt = true,
  after = 'nvim-cmp',
}

M.config = function() -- code to run after plugin loaded
  vim.cmd [[py3 from snippet_tools.cpp import register_postfix_snippets]]
  vim.cmd [[py3 register_postfix_snippets()]]
end

return M

-- vim: et sw=2 ts=2 fdm=marker

