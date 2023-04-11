local M = {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  cmd = { 'NvimTreeFindFile' },
}

M.init = function()
  local Menu = require 'nui.menu'
  local menu = require 'ht.core.menu'

  menu:append_section('*', {
    Menu.item('Find file in FileExplorer', {
      action = function()
        vim.cmd 'NvimTreeFindFile'
      end,
    }),
  }, 100)
end

M.config = function() -- code to run after plugin loaded
  require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = { hint = "", info = "", warning = "", error = "" },
    },
    modified = { enable = true },
    update_focused_file = { enable = false, update_cwd = false,
                            ignore_list = {} },
    system_open = { cmd = nil, args = {} },
    filters = { dotfiles = false, custom = {} },
    git = { ignore = false },
    view = {
      width = 30,
      hide_root_folder = false,
      side = 'left',
      mappings = { custom_only = false, list = {} },
    },
    actions = { open_file = { resize_window = false } },
  }
end

local jump_to_nvim_tree = function()
  local n = vim.api.nvim_call_function('winnr', { '$' })
  -- find existing nvim-tree-window
  for i = 1, n do
    local win_id = vim.api.nvim_call_function('win_getid', { i })
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = vim.api.nvim_buf_get_option(buf_id, 'ft')

    if tp == 'NvimTree' then
      vim.cmd(i .. 'wincmd w')
      return
    end
  end

  require("nvim-tree.api").tree.toggle {
    find_file = false,
    focus = true,
    path = nil,
    update_root = false,
  }
end

M.keys = {
  { '<F3>', jump_to_nvim_tree, desc = 'file-explorer' },
  { '<leader>ft', jump_to_nvim_tree, desc = 'file-explorer' },
}

return M
