return {
  {
    'TwIStOy/cpp-toolkit.nvim',
    config = function()
      require'cpp-toolkit'.setup()
    end,
    cmd = { 'CppGenDef', 'Telescope' },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  },
}

