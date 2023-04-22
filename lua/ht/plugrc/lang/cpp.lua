return {
  {
    'TwIStOy/cpp-toolkit.nvim',
    config = function()
      require'cpp-toolkit'.setup()
    end,
    cmd = { 'CppGenDef', 'CppDebugPrint', 'CppToolkit', 'Telescope' },
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    keys = {
      {
        '<C-f>i',
        function()
          vim.cmd [[Telescope cpptoolkit insert_header]]
        end,
        desc = 'insert-header',
        mode = { 'i', 'n' },
      },
      {
        '<C-f>m',
        function()
          require'cpp-toolkit.functions.shortcut'.shortcut_move_value()
        end,
        desc = 'move-value',
        mode = { 'n' },
      },
      {
        '<C-f>f',
        function()
          require'cpp-toolkit.functions.shortcut'.shortcut_forward_value()
        end,
        desc = 'forward-value',
        mode = { 'n' },
      },
    },
  },
}
