return {
  { import = "ht.plugrc.editor.motion" },

  -- matchup parens
  {
    'andymass/vim-matchup',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    init = function() -- code to run before plugin loaded
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 50
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.g.matchup_matchparen_hi_surround_always = 2
      vim.g.matchup_matchparen_offscreen = {
        method = 'popup',
        highlight = 'CurrentWord',
      }
      vim.g.matchup_delim_start_plaintext = 1
      vim.g.matchup_motion_override_Npercent = 0
      vim.g.matchup_motion_cursor_end = 0
      vim.g.matchup_mappings_enabled = 0
    end,
    config = function() -- code to run after plugin loaded
      vim.cmd [[hi! link MatchWord Underlined]]

      vim.cmd [[
        aug Matchup
          au!
          au TermOpen * let [b:matchup_matchparen_enabled, b:matchup_matchparen_fallback] = [0, 0]
        aug END
      ]]

      vim.api.nvim_set_keymap('n', '%', '<plug>(matchup-%)', { silent = true })
      vim.api.nvim_set_keymap('x', '%', '<plug>(matchup-%)', { silent = true })
      vim.api.nvim_set_keymap('o', '%', '<plug>(matchup-%)', { silent = true })
    end,
  },

  -- vim-surround
  {
    'tpope/vim-surround',
    event = 'BufReadPost',
    init = function()
      vim.g.surround_no_mappings = 0
      vim.g.surround_no_insert_mappings = 1
    end,
  },

  -- fast move
  {
    'matze/vim-move',
    keys = {
      { '<C-h>', nil, mode = { 'n', 'v' } },
      { '<C-j>', nil, mode = { 'n', 'v' } },
      { '<C-k>', nil, mode = { 'n', 'v' } },
      { '<C-l>', nil, mode = { 'n', 'v' } },
    },
    init = function()
      vim.g.move_key_modifier = 'C'
      vim.g.move_key_modifier_visualmode = 'C'
    end,
  },

  -- resolve git conflict
  {
    'TwIStOy/conflict-resolve.nvim',
    keys = {
      {
        '<leader>v1',
        '<cmd>call conflict_resolve#ourselves()<CR>',
        desc = 'select-ours',
      },
      {
        '<leader>v2',
        '<cmd>call conflict_resolve#themselves()<CR>',
        desc = 'select-them',
      },
      {
        '<leader>vb',
        '<cmd>call conflict_resolve#both()<CR>',
        desc = 'select-both',
      },
    },
  },

  -- big J
  {
    'osyo-manga/vim-jplus',
    event = 'BufReadPost',
    keys = { { 'J', '<Plug>(jplus)', mode = { 'n', 'v' }, noremap = false } },
  },

  -- tabular
  { 'godlygeek/tabular', cmd = { 'Tabularize' } },
  {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign' },
    dependencies = { 'godlygeek/tabular' },
    keys = {
      { '<leader>ta', '<cmd>EasyAlign<CR>', desc = 'easy-align' },
      { '<leader>ta', '<cmd>EasyAlign<CR>', mode = 'x', desc = 'easy-align' },
    },
  },

  -- markdown table
  { 'dhruvasagar/vim-table-mode', ft = { 'markdown' } },

  -- dash, only macos supported
  {
    'mrjones2014/dash.nvim',
    build = 'make install',
    lazy = true,
    cmd = { 'Dash', 'DashWord' },
    cond = function()
      return vim.fn.has('macunix')
    end,
    opts = {
      dash_app_path = '/Applications/Setapp/Dash.app',
      search_engine = 'google',
      file_type_keywords = {
        dashboard = false,
        NvimTree = false,
        TelescopePrompt = false,
        terminal = false,
        packer = false,
        fzf = false,
      },
    },
  },

  -- remove buffers
  {
    "kazhala/close-buffers.nvim",
    lazy = true,
    cmd = { 'BDelete', 'BWipeout' },
    config = function()
      require('close_buffers').setup {
        filetype_ignore = {
          'dashboard',
          'NvimTree',
          'TelescopePrompt',
          'terminal',
          'toggleterm',
          'packer',
          'fzf',
        },
        preserve_window_layout = { 'this' },
        next_buffer_cmd = function(windows)
          require('bufferline').cycle(1)
          local bufnr = vim.api.nvim_get_current_buf()
          for _, window in ipairs(windows) do
            vim.api.nvim_win_set_buf(window, bufnr)
          end
        end,
      }
    end,
    keys = {
      {
        "<leader>ch",
        function()
          require('close_buffers').delete({ type = 'hidden' })
          vim.cmd("redrawtabline")
          vim.cmd("redraw")
        end,
        desc = 'clear-hidden-buffers',
      },
    },
  },

  -- hlsearch
  {
    'kevinhwang91/nvim-hlslens',
    lazy = true,
    config = function()
      require("hlslens").setup({
        calm_down = false,
        nearest_only = false,
        nearest_float_when = "never",
      })
    end,
    keys = {
      { '*', "*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { '#', "#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { 'g*', "g*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { 'g#', "g#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      {
        'n',
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        'N',
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
    },
  },

  -- obsidian
  { import = 'ht.plugrc.editor.obsidian' },

  -- <c-a> <c-x>
  { import = 'ht.plugrc.editor.dial' },

  -- session management
  {
    'jedrzejboczar/possession.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    opts = {
      silent = true,
      commands = {
        save = 'SSave',
        load = 'SLoad',
        delete = 'SDelete',
        list = 'SList',
      },
    },
  },

  -- ufo
  {
    'kevinhwang91/nvim-ufo',
    enabled = false,
    event = { 'BufReadPost' },
    keys = { { 'zR', nil, 'zM', nil } },
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      NMAP('zR', require('ufo').openAllFolds, 'open-all-folds')
      NMAP('zM', require('ufo').closeAllFolds, 'close-all-folds')

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      })
    end,
  },

  -- linediff
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },

  -- post code to 0x0.st
  {
    'rktjmp/paperplanes.nvim',
    lazy = true,
    cmd = { 'PP' },
    config = function()
      require("paperplanes").setup({
        register = "+",
        provider = "0x0.st",
        provider_options = {},
        notifier = vim.notify or print,
      })
    end,
  },
}
