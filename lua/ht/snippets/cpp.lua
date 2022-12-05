local M = {}

M.all_snippets = function()
  local ls = require 'luasnip'
  local s = ls.snippet
  local sn = ls.snippet_node
  local isn = ls.indent_snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node
  local c = ls.choice_node
  local d = ls.dynamic_node
  local r = ls.restore_node
  local events = require "luasnip.util.events"
  local ai = require "luasnip.nodes.absolute_indexer"
  local extras = require "luasnip.extras"
  local fmt = extras.fmt
  local m = extras.m
  local l = extras.l
  local postfix = require"luasnip.extras.postfix".postfix

  local copyright = {
    {
      trig = 'cr',
      name = 'copyright',
      wordTrig = true,
      snippetType = 'autosnippet',
    },
    {
      t("// Copyright (c) 2020 - present, "),
      -- todo
    },
    {
      condition = function(...)
        local row, _ = vim.api.nvim_win_get_cursor(0)
        return row == 1
      end,

    },
  }

end

return M
