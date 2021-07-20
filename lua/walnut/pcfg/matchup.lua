module('walnut.pcfg.matchup', package.seeall)

local keymap = vim.api.nvim_set_keymap

function setup()
  vim.g.matchup_surround_enabled = 1
  vim.g.matchup_matchparen_timeout = 100
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_deferred_show_delay = 50
  vim.g.matchup_matchparen_deferred_hide_delay = 300
  vim.g.matchup_matchparen_hi_surround_always = 2
  vim.g.matchup_matchparen_offscreen = {
    method = 'popup',
    highlight = 'CurrentWord'
  }
  vim.g.matchup_delim_start_plaintext = 1
  vim.g.matchup_motion_override_Npercent = 0
  vim.g.matchup_motion_cursor_end = 0
  vim.g.matchup_mappings_enabled = 0
end

function config()
  vim.cmd [[hi! link MatchWord Underlined]]

  vim.api.nvim_set_keymap('n', '%', [[<Plug>(matchup-%)]], {silent = true})
  vim.api.nvim_set_keymap('x', '%', [[<Plug>(matchup-%)]], {silent = true})
  vim.api.nvim_set_keymap('o', '%', [[<Plug>(matchup-%)]], {silent = true})
  vim.api.nvim_set_keymap('n', '[[', '<Plug>(matchup-[%)', {silent = true})
  vim.api.nvim_set_keymap('x', '[[', '<Plug>(matchup-[%)', {silent = true})
  vim.api.nvim_set_keymap('o', '[[', '<Plug>(matchup-[%)', {silent = true})
  vim.api.nvim_set_keymap('n', ']]', '<Plug>(matchup-]%)', {silent = true})
  vim.api.nvim_set_keymap('x', ']]', '<Plug>(matchup-]%)', {silent = true})
  vim.api.nvim_set_keymap('o', ']]', '<Plug>(matchup-]%)', {silent = true})

  vim.cmd [[
    aug Matchup
      au!
      au TermOpen * let let [b:matchup_matchparen_enabled, b:matchup_matchparen_fallback] = [0, 0]
    aug END
  ]]
end

