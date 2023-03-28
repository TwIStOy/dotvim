local M = {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'TwIStOy/ultisnips',
    'onsails/lspkind.nvim',
    'lukas-reineke/cmp-under-comparator',
    'quangnguyen30192/cmp-nvim-ultisnips',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-calc',
    'dmitmel/cmp-digraphs',
    'f3fora/cmp-spell',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'zbirenbaum/copilot-cmp',
    'zbirenbaum/copilot.lua',
  },
}

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
             vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                 '^%s*$') == nil
end

local fix_menu_abbr = function(abbr)
  -- if length greater than 1
  if #abbr < 1 then
    return abbr
  end

  local ch = abbr:sub(1, 1)
  if ch == ' ' or ch == '•' then
    return abbr
  end
  return ' ' .. abbr
end

M.config = function()
  local cmp = require 'cmp'
  local lspkind = require 'lspkind'

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
        winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompBorder',
      },
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = 'NormalFloat:CompNormal,FloatBorder:FloatBorder',
      },
    },
    sources = {
      { name = "nvim_lsp", group_index = 1 },
      { name = "copilot", group_index = 1 },
      { name = "ultisnips", group_index = 2 },
      { name = 'nvim_lsp_signature_help', group_index = 3 },
      { name = 'path', group_index = 4 },
      { name = 'calc', group_index = 5 },
      {
        name = 'buffer',
        group_index = 5,
        option = {
          get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api
                                                              .nvim_buf_line_count(
                                                              buf))
            if byte_size > 1024 * 1024 then -- 1 Megabyte max
              return {}
            end
            return { buf }
          end,
        },
      },
    },
    completion = { completeopt = "menu,menuone,noselect,noinsert" },
    mapping = {
      ["<CR>"] = cmp.mapping(function(fallback)
        if not cmp.visible() then
          fallback()
          return
        end
        local entry = cmp.get_selected_entry()
        if entry == nil then
          entry = cmp.core.view:get_first_entry()
        end
        if entry == nil then
          fallback()
          return
        end
        if vim.g.global_rime_enabled and entry.source ~= nil and
            entry.source.name == 'nvim_lsp' and entry.source.source ~= nil and
            entry.source.source.client ~= nil and
            entry.source.source.client.name == 'rime_ls' then
          -- if rime enabled, do not confirm
          cmp.abort()
        else
          if cmp.get_selected_entry() ~= nil then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace,
                          select = false })
          else
            fallback()
          end
        end
      end, { 'i', 'c' }),
      ["<Space>"] = cmp.mapping(function(fallback)
        if not cmp.visible() then
          fallback()
          return
        end
        local entry = cmp.get_selected_entry()
        if entry == nil then
          entry = cmp.core.view:get_first_entry()
        end
        if entry == nil then
          fallback()
          return
        end
        if entry ~= nil and vim.g.global_rime_enabled and entry.source.name ==
            'nvim_lsp' and entry.source.source.client.name == 'rime_ls' then
          -- cmp enabled
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        else
          fallback()
        end
      end, { 'i', 's' }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<TAB>"] = cmp.mapping(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        local kind = lspkind.cmp_format({
          mode = "symbol_text",
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
        })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.abbr = fix_menu_abbr(kind.abbr)
        kind.kind = " " .. strings[1] .. " "
        if #strings[2] > 0 then
          kind.menu = "    (" .. strings[2] .. ")"
        else
          kind.menu = ""
        end
        return kind
      end,
    },
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
    end,
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        require"cmp-under-comparator".under,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end

return M
