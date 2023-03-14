local function setup_keymaps()
  local mapping = require 'ht.core.mapping'
  mapping.map({
    keys = { 'g', 'f' },
    action = function()
      if require'obsidian'.util.cursor_on_markdown_link() then
        vim.api.nvim_command('ObsidianFollowLink')
      end
    end,
  }, 0)
end

local M = {
  'epwalsh/obsidian.nvim',
  lazy = true,
  dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
  cond = function()
    return require'ht.core.globals'.has_obsidian_vault
  end,
  ft = { 'markdown' },
}

function M.config()
  local obsidian = require'obsidian'.setup {
    dir = require'ht.core.globals'.obsidian_vault,
    notes_subdir = 'Database',
    completion = { nvim_cmp = true },
    use_advanced_uri = true,
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(' ', '-'):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(97, 122))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,
  }

  local au_group = vim.api.nvim_create_augroup("obsidian_extra_setup",
                                               { clear = true })
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = au_group,
    pattern = tostring(obsidian.dir / '**.md'),
    callback = function()
      setup_keymaps()
    end,
  })
end

return M
