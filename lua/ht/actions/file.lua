module('ht.actions.file', package.seeall)

function OpenProjectRoot()
  if not packer_plugins['telescope.nvim'].loaded then
    require'packer'.loader 'telescope.nvim'
  end

  if vim.b._dotvim_resolved_project_root ~= nil then
    require'telescope.builtin'.find_files {
      cwd = vim.b._dotvim_resolved_project_root,
      no_ignore = true,
      follow = true
    }
  else
    require'telescope.builtin'.find_files {}
  end
end

-- vim: et sw=2 ts=2 fdm=marker

