return {
  {
    'TwIStOy/cpp-toolkit.nvim',
    config = function()
      require("telescope").load_extension('cpptoolkit')
      require'cpp-toolkit'.setup()
      require 'ht.core.functions':add_function_set{
        category = "CppToolkit",
        functions = {
          {
            title = 'Quickfix: move value',
            f = function()
              require'cpp-toolkit.functions.shortcut'.shortcut_move_value()
            end,
          },
          {
            title = 'Quickfix: forward value',
            f = function()
              require'cpp-toolkit.functions.shortcut'.shortcut_forward_value()
            end,
          },
          {
            title = 'Fuzzy find header and insert',
            f = function()
              vim.cmd "Telescope cpptoolkit insert_header"
            end,
          },
          {
            title = 'Generate function implementation body',
            f = function()
              vim.cmd "CppGenDef"
            end,
          },
          {
            title = 'Add debug print statement',
            f = function()
              vim.cmd "CppDebugPrint"
            end,
          },
        },
      }
    end,
    ft = { 'cpp', 'c' },
    cmd = { 'CppGenDef', 'CppDebugPrint', 'CppToolkit' },
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
