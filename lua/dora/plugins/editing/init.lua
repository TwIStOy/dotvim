local lib = require("dora.lib")

---@type dora.lib.PluginOptions[]
return {
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "gcc", desc = "toggle-line-comment" },
      { "gcc", mode = "x", desc = "toggle-line-comment" },
      { "gbc", desc = "toggle-block-comment" },
      { "gbc", mode = "x", desc = "toggle-block-comment" },
    },
    opts = {
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gcc", block = "gbc" },
      mappings = { basic = true, extra = false },
      pre_hook = function()
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      end,
    },
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    config = true,
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
    actions = lib.plugin.action.make_options {
      from = "diffview.nvim",
      category = "Diffview",
      ---@param buffer dora.lib.vim.Buffer
      condition = function(buffer)
        -- TODO(Hawtian Wang): check if file in gitignore
        return lib.fs.in_git_repo(buffer)
      end,
      ---@type dora.lib.ActionOptions[]
      actions = {
        {
          id = "diffview.open",
          title = "Open diffview",
          callback = "DiffviewOpen",
        },
        {
          id = "diffview.close",
          title = "Close the current diffview. You can also use :tabclose.",
          callback = "DiffviewClose",
        },
        {
          id = "diffview.toggle",
          title = "Toggle the file panel.",
          callback = "DiffviewToggleFiles",
        },
        {
          id = "diffview.focus",
          title = "Bring focus to the file panel.",
          callback = "DiffviewFocusFiles",
        },
        {
          id = "diffview.refresh",
          title = "Update stats and entries in the file list of the current Diffview.",
          callback = "DiffviewRefresh",
        },
      },
    },
  },
  require("dora.plugins.editing.nvim-cmp"),
  require("dora.plugins.editing.flash"),
  {
    "akinsho/git-conflict.nvim",
    config = true,
    opts = {
      default_mappings = false,
    },
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
    },
    gui = "all",
    actions = lib.plugin.action.make_options {
      from = "git-conflict.nvim",
      category = "GitConflict",
      ---@param buffer dora.lib.vim.Buffer
      condition = function(buffer)
        return lib.fs.in_git_repo(buffer)
      end,
      ---@type dora.lib.ActionOptions[]
      actions = {
        {
          id = "git-conflict.choose-ours",
          title = "Choose ours",
          callback = "GitConflictChooseOurs",
        },
        {
          id = "git-conflict.choose-theirs",
          title = "Choose theirs",
          callback = "GitConflictChooseTheirs",
        },
        {
          id = "git-conflict.choose-both",
          title = "Choose both",
          callback = "GitConflictChooseBoth",
        },
        {
          id = "git-conflict.choose-none",
          title = "Choose none",
          callback = "GitConflictChooseNone",
        },
        {
          id = "git-conflict.next-conflict",
          title = "Next conflict",
          callback = "GitConflictNextConflict",
        },
        {
          id = "git-conflict.prev-conflict",
          title = "Previous conflict",
          callback = "GitConflictPrevConflict",
        },
      },
    },
  },
  {
    "phaazon/hop.nvim",
    cmd = {
      "HopWord",
      "HopPattern",
      "HopChar1",
      "HopChar2",
      "HopLine",
      "HopLineStart",
    },
    opts = { keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 },
    actions = lib.plugin.action.make_options {
      from = "hop.nvim",
      category = "Hop",
      ---@type dora.lib.ActionOptions[]
      actions = {
        {
          id = "hop.word",
          title = "Hop to word",
          callback = "HopWord",
        },
        {
          id = "hop.pattern",
          title = "Hop to pattern",
          callback = "HopPattern",
        },
        {
          id = "hop.char1",
          title = "Hop to char1",
          callback = "HopChar1",
        },
        {
          id = "hop.char2",
          title = "Hop to char2",
          callback = "HopChar2",
        },
        {
          id = "hop.line",
          title = "Hop to line",
          callback = "HopLine",
          keys = { ",l", desc = "jump-to-line" },
        },
        {
          id = "hop.line-start",
          title = "Hop to line start",
          callback = "HopLineStart",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup {
        calm_down = false,
        nearest_only = false,
        nearest_float_when = "never",
      }
    end,
    keys = {
      { "*", "*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>", silent = true },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>", silent = true },
      {
        "n",
        "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
      {
        "N",
        "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      },
    },
  },
}
