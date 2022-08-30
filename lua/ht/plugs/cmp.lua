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

  vim.cmd [[
    highlight CompNormal guibg=None guifg=None
    highlight CompBorder guifg=#ffaa55 guibg=#None
    autocmd! ColorScheme * highlight CompBorder guifg=#ffaa55 guibg=None
  ]]

  cmp.setup {
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    window = {
      completion = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        -- winhighlight = 'NormalFloat:NormalFloat,CompBorder:CompBorder',
        winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompBorder',
      },
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        -- winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompDocBorder',
        winhighlight = 'NormalFloat:CompNormal,FloatBorder:FloatBorder',
      },
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "ultisnips" },
      { name = 'path' },
      { name = 'calc' },
      { name = 'spell' },
    },
    completion = { completeopt = "menu,menuone,noselect,noinsert" },
    mapping = {
      ["<CR>"] = cmp.mapping(cmp.mapping.confirm(), { 'i', 'c' }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<TAB>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end
      end, { "i" }),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
      ['<C-f>'] = cmp.mapping(function(fallback)
        cmp_ultisnips_mappings.compose { "expand", "jump_forwards" }(fallback)
      end, { 'i', 's' }),
      ['<C-b>'] = cmp.mapping(function(fallback)
        cmp_ultisnips_mappings.compose { "jump_backwards" }(fallback)
      end, { 'i', 's' }),
    },
    formatting = {
      format = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 }),
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        require "clangd_extensions.cmp_scores",
        require"cmp-under-comparator".under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = 'path' },
      { { name = 'cmdline' }, { name = 'cmdline_history' } },
    },
  })
end

-- vim: et sw=2 ts=2

