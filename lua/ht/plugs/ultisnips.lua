module('ht.plugs.ultisnips', package.seeall)

local set_g_var = vim.api.nvim_set_var
local cmd = vim.api.nvim_command

function setup()
  set_g_var('UltiSnipsExpandTrigger', '<c-e>')
  set_g_var('UltiSnipsJumpForwardTrigger', '<c-f>')
  set_g_var('UltiSnipsJumpBackwardTrigger', '<c-b>')
end

function config()
  cmd([[py3 from snippet_tools.cpp import register_postfix_snippets]])
  cmd([[py3 register_postfix_snippets()]])
end

-- vim: et sw=2 ts=2

