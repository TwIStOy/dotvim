module('ht.plugs.cmp', package.seeall)

function setup()
end

function config()
  local cmp = require 'cmp'
  local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
  local lspkind = require('lspkind')

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match('%s') == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end
    },
    sources = {{name = "nvim_lsp"}, {name = "luasnip"}},
    completion = {completeopt = "menu,menuone,noinsert"},
    mapping = {
      ["<CR>"] = cmp.mapping(cmp.mapping.confirm(), {'i', 'c'}),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<TAB>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end
      end, {"i"}),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),
      ['<C-e>'] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end,
        {'i'}
      )
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
      })
    }

  })

  cmp.setup.cmdline(':', {sources = {{name = 'path'}, {name = 'cmdline'}}})
end

-- vim: et sw=2 ts=2

