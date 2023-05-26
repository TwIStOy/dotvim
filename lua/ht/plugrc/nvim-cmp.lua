local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "onsails/lspkind.nvim",
    "lukas-reineke/cmp-under-comparator",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-cmdline",
    "dmitmel/cmp-cmdline-history",
    "hrsh7th/cmp-nvim-lsp",
    "FelipeLema/cmp-async-path",
    "hrsh7th/cmp-calc",
    "dmitmel/cmp-digraphs",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-buffer",
    "kdheepak/cmp-latex-symbols",
    {
      "paopaol/cmp-doxygen",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    "jcdickinson/codeium.nvim",
    "zbirenbaum/copilot-cmp",
  },
}

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        :match("^%s*$")
      == nil
end

local i_cr_action = function(fallback)
  local cmp = require("cmp")

  if not cmp.visible() then
    fallback()
    return
  end

  -- test the first entry is rime_ls or not
  local entry = cmp.get_selected_entry()
  if entry == nil then
    entry = cmp.core.view:get_first_entry()
  end
  if entry == nil then
    -- entry still nil, fallback
    fallback()
    return
  end

  if
    entry.source ~= nil
    and entry.source.name == "nvim_lsp"
    and entry.source.source ~= nil
    and entry.source.source.client ~= nil
    and entry.source.source.client.name == "rime_ls"
  then
    -- if the first entry is from rime_ls, do not confirm, <CR> now is a simple
    -- new line marker
    cmp.abort()
    return
  end

  -- otherwise, confirm the selected entry
  entry = cmp.get_selected_entry()
  if cmp.get_selected_entry() ~= nil then
    -- if there's a selected entry, including preselect entry
    cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
  else
    fallback()
  end
end

local function in_latex_scope()
  local context = require("cmp.config.context")
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft ~= "markdown" and ft ~= "latex" then
    return false
  end
  return context.in_treesitter_capture("text.math")
end

M.config = function()
  local cmp = require("cmp")
  local lspkind = require("lspkind")

  cmp.setup {
    matching = {
      disallow_fuzzy_matching = true,
      disallow_fullfuzzy_matching = true,
      disallow_partial_fuzzy_matching = false,
      disallow_partial_matching = false,
    },
    preselect = cmp.PreselectMode.Item,
    experimental = { ghost_text = false },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        border = "solid",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
      documentation = {
        border = "single",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
    sources = {
      { name = "nvim_lsp", group_index = 1, max_item_count = 100 },
      { name = "copilot", group_index = 1 },
      { name = "codeium", group_index = 1 },
      { name = "luasnip", group_index = 1 },
      {
        name = "latex_symbols",
        group_index = 1,
        option = {
          strategy = 2, -- latex only
        },
        entry_filter = function(e, ctx)
          if ctx.in_latex_scope == nil then
            ctx.in_latex_scope = in_latex_scope()
          end
          return ctx.in_latex_scope
        end,
      },
      { name = "async_path", group_index = 4 },
      { name = "calc", group_index = 5 },
      {
        name = "buffer",
        group_index = 5,
        option = {
          get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size =
              vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if byte_size > 1024 * 1024 then -- 1 Megabyte max
              return {}
            end
            return { buf }
          end,
        },
        max_item_count = 10,
      },
    },
    completion = { completeopt = "menu,menuone,noselect,noinsert,preview" },
    mapping = {
      ["<CR>"] = cmp.mapping(i_cr_action, { "i", "c" }),
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
        if
          entry ~= nil
          and vim.g.global_rime_enabled
          and entry.source.name == "nvim_lsp"
          and entry.source.source.client.name == "rime_ls"
        then
          -- cmp enabled
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping.select_prev_item {},
      ["<C-n>"] = cmp.mapping.select_next_item {},
      ["<C-k>"] = cmp.mapping.select_prev_item {},
      ["<C-j>"] = cmp.mapping.select_next_item {},
      ["<C-e>"] = cmp.mapping.abort(),
      ["<TAB>"] = cmp.mapping(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        else
          fallback()
        end
      end, { "i" }),
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
      ["<C-f>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s", "n" }),
      ["<C-b>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = lspkind.cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          before = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buf]",
              nvim_lsp = "[LSP]",
              ultisnips = "[Snip]",
              luasnip = "[Snip]",
              nvim_lua = "[Lua]",
              orgmode = "[Org]",
              path = "[Path]",
              dap = "[DAP]",
              emoji = "[Emoji]",
              calc = "[CALC]",
              latex_symbols = "[LaTeX]",
              cmdline_history = "[History]",
              cmdline = "[Command]",
              copilot = "[Copilot]",
              codeium = "[Codeium]",
            })[entry.source.name] or ("[" .. entry.source.name .. "]")
            if entry.source.name == "latex_symbols" then
              vim_item.kind = "Math"
            end
            return vim_item
          end,
        }(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. strings[1] .. "  "
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
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end

return M
