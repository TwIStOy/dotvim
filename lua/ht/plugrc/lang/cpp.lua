return {
  {
    'TwIStOy/cpp-toolkit.nvim',
    config = function()
      require'cpp-toolkit'.setup()
    end,
    cmd = { 'CppGenDef', 'Telescope' },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    keys = {
      {
        '<C-e><C-i>',
        function()
          vim.cmd [[Telescope cpptoolkit insert_header]]
        end,
        desc = 'insert-header',
        mode = { 'i', 'n' },
      },
    },
  },
}

