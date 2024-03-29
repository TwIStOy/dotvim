---@type dora.core.plugin.PluginOption
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-calc",
    "lukas-reineke/cmp-under-comparator",
  },
  opts = function()
    local cmp = require("cmp")

    return {
      matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
      },
      preselect = cmp.PreselectMode.None,
      experimental = { ghost_text = false },
      window = {
        completion = {
          border = "none",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          focusable = false,
          col_offset = 0,
        },
        documentation = {
          border = "single",
          winhighlight = "FloatBorder:FloatBorder",
          focusable = false,
        },
      },
      sources = {
        { name = "nvim_lsp", group_index = 1, max_item_count = 100 },
        { name = "async_path", group_index = 4 },
        {
          name = "buffer",
          group_index = 5,
          option = {
            get_bufnrs = function()
              local buf = vim.api.nvim_get_current_buf()
              local byte_size = vim.api.nvim_buf_get_offset(
                buf,
                vim.api.nvim_buf_line_count(buf)
              )
              if byte_size > 1024 * 1024 then -- 1 Megabyte max
                return {}
              end
              return { buf }
            end,
          },
          max_item_count = 10,
        },
      },
      completion = {
        completeopt = "menu,menuone,noselect,noinsert,preview",
      },
      mapping = {
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-p>"] = cmp.mapping.select_prev_item {},
        ["<C-n>"] = cmp.mapping.select_next_item {},
        ["<C-k>"] = cmp.mapping.select_prev_item {},
        ["<C-j>"] = cmp.mapping.select_next_item {},
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
      },
      enabled = function()
        local bt = vim.api.nvim_get_option_value("buftype", {
          buf = 0,
        })
        return bt ~= "prompt"
      end,
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    }
  end,
}
