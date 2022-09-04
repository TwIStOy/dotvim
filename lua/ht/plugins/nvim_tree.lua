local M = {}

M.core = {
  'kyazdani42/nvim-tree.lua',
  opt = true,
  requires = { 'kyazdani42/nvim-web-devicons' },
}

M.config = function() -- code to run after plugin loaded
  require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    diagnostics = {
      enable = false,
      icons = { hint = "", info = "", warning = "", error = "" },
    },
    update_focused_file = { enable = false, update_cwd = false,
                            ignore_list = {} },
    system_open = { cmd = nil, args = {} },
    filters = { dotfiles = false, custom = {} },
    view = {
      width = 30,
      height = 30,
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
      vim.cmd [[i .. 'wincmd w']]
      return
    end
  end

  -- force load nvim-tree and open window
  if not (packer_plugins and packer_plugins[name] and
      packer_plugins[name].loaded) then
    require'packer'.loader 'nvim-tree.lua'
  end
  require'nvim-tree'.toggle()
end

M.mappings = function() -- code for mappings
  local mapping = require 'ht.core.mapping'

  mapping.map {
    keys = { '<F3>' },
    action = jump_to_nvim_tree,
    desc = 'file-explorer',
  }

  mapping.map {
    keys = { '<leader>', 'f' },
    action = jump_to_nvim_tree,
    desc = 'file-explorer',
  }
end

return M

-- vim: et sw=2 ts=2 fdm=marker

