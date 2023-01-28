return {
  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope' },
    opts = function()
      local actions = require 'telescope.actions'
      return {
        defaults = {
          selection_caret = "➤ ",

          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",

          history = { path = '~/.local/share/nvim/telescope_history.sqlite3' },

          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯',
                          '╰' },
          color_devicons = true,

          mappings = {
            i = {
              ["<C-n>"] = false,
              ["<C-p>"] = false,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
        },
      }
    end,
    keys = {
      { '<F4>', '<cmd>Telescope buffers<CR>', desc = 'f-buffers' },
      {
        { '<leader>e' },
        function()
          if vim.b._dotvim_resolved_project_root ~= nil then
            require'telescope.builtin'.find_files {
              cwd = vim.b._dotvim_resolved_project_root,
              no_ignore = true,
              follow = true,
            }
          else
            require'telescope.builtin'.find_files {}
          end
        end,
        desc = 'edit-project-file',
      },
      {
        '<leader>ls',
        '<cmd>Telescope lsp_document_symbols<CR>',
        desc = 'document-symbols',
      },
      {
        '<leader>lw',
        '<cmd>Telescope lsp_workspace_symbols<CR>',
        desc = 'workspace-symbols',
      },
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      key_labels = { ["<space>"] = "SPC", ["<cr>"] = "RET", ["<tab>"] = "TAB" },
      layout = { align = 'center' },
      ignore_missing = false,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:",
                 "^ " },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register {
        mode = { "n", "v" },

        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },

        ["<leader>l"] = { name = "+list" },
      }
    end,
  },

  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "<leader>vm", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
      end,
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
          pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
        end,
      })
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "toggle-trouble-window" },
      {
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "document-diagnostics",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "workspace-diagnostics",
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    lazy = true,
    opts = {
      highlight = { keyword = 'bg', pattern = [[.*<(KEYWORDS)\([^)]*\):]] },
    },
  },

  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  },

  -- motion
  {
    'phaazon/hop.nvim',
    cmd = {
      'HopWord',
      'HopPattern',
      'HopChar1',
      'HopChar2',
      'HopLine',
      'HopLineStart',
    },
    opts = { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 },
    keys = {
      { 's', '<cmd>HopWord<CR>', desc = 'jump-word' },
      { ',,', '<cmd>HopWord<CR>', desc = 'jump-word' },
      { ',l', '<cmd>HopLine<CR>', desc = 'jump-line' },
    },
  },
}
