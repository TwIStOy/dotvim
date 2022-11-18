local M = {}

M.core = {
  'hrsh7th/nvim-cmp',
  requires = {
    { 'onsails/lspkind.nvim' },

    -- all should be loaded in-order
    { "quangnguyen30192/cmp-nvim-ultisnips", after = 'ultisnips' },
    { 'hrsh7th/cmp-cmdline', after = 'cmp-nvim-ultisnips' },
    { 'dmitmel/cmp-cmdline-history', after = 'cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-cmdline-history' },
    { 'hrsh7th/cmp-path', after = 'cmp-nvim-lsp' },
    { 'hrsh7th/cmp-calc', after = 'cmp-path' },
    { 'dmitmel/cmp-digraphs', after = 'cmp-calc' },
    { 'f3fora/cmp-spell', after = 'cmp-digraphs' },
    { 'hrsh7th/cmp-buffer', after = 'cmp-spell' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'cmp-buffer' },
    -- { 'rcarriga/cmp-dap', after = 'cmp-nvim-lsp-signature-help' },
    { 'lukas-reineke/cmp-under-comparator', module = 'cmp-under-comparator' },
    {
      'zbirenbaum/copilot-cmp',
      requires = { 'zbirenbaum/copilot.lua' },
      after = 'copilot.lua',
    },
  },
  event = 'InsertEnter',
}

M.config = function() -- code to run after plugin loaded
  require("cmp_nvim_ultisnips").setup {}

  -- init copilot
  require'copilot_cmp'.setup()

  local cmp = require 'cmp'
  local lspkind = require 'lspkind'

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                   '^%s*$') == nil
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
      { name = "copilot" },
      { name = "ultisnips" },
      { name = 'nvim_lsp_signature_help' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'spell' },
      { name = 'buffer' },
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
          fallback()
        end
      end, { "i" }),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
      ['<C-f>'] = cmp.mapping(function(fallback)
        local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
        cmp_ultisnips_mappings.compose { "expand", "jump_forwards" }(fallback)
      end, { 'i', 's' }),
      ['<C-b>'] = cmp.mapping(function(fallback)
        local cmp_ultisnips_mappings = require "cmp_nvim_ultisnips.mappings"
        cmp_ultisnips_mappings.compose { "jump_backwards" }(fallback)
      end, { 'i', 's' }),
    },
    formatting = {
      format = lspkind.cmp_format {
        maxwidth = 50,
        ellipsis_char = '...',
        before = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buf]',
            nvim_lsp = '[LSP]',
            ultisnips = '[Snip]',
            nvim_lua = '[Lua]',
            orgmode = '[Org]',
            path = '[Path]',
            dap = '[DAP]',
            emoji = '[Emoji]',
            calc = '[CALC]',
            latex_symbols = '[LaTeX]',
            cmdline_history = '[History]',
            cmdline = '[Command]',
            copilot = '[Copilot]',
          })[entry.source.name] or ('[' .. entry.source.name .. ']')
          return vim_item
        end,
      },
    },
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
      -- or require("cmp_dap").is_dap_buffer()
    end,
    sorting = {
      comparators = {
        require"copilot_cmp.comparators".prioritize,
        require"copilot_cmp.comparators".score,

        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        -- require "clangd_extensions.cmp_scores",
        require"cmp-under-comparator".under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = 'path' },
      { { name = 'cmdline' }, { name = 'cmdline_history' } },
    },
  })

  --[[
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches" },
                                { sources = { { name = "dap" } } })
  --]]
end

M.mappings = function() -- code for mappings
end

return M

-- vim: et sw=2 ts=2 fdm=marker

