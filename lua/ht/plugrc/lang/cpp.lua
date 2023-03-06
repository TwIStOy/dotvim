return {
  {
    'TwIStOy/cpp-toolkit.nvim',
    config = function()
      require'cpp-toolkit'.setup()
    end,
    cmd = { 'CppGenDef' },
  },
}

