return {
  {
    dir = '/home/hawtian/project/cpp-toolkit.nvim',
    dev = true,
    config = function()
      require'cpp-toolkit'.setup()
    end,
    cmd = { 'CppGenDef' },
  },
}

