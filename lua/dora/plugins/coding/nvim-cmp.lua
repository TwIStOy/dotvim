---@type dora.core.plugin.PluginOptions[]
return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
    },
    opts = function()
      local cmp = require("cmp")

      -- TODO(Hawtian Wang): fix this ugly hack for `rime_ls`, both `<CR>` and `<Space>`
      local i_cr_action = function(fallback)
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
        if entry == nil then
          fallback()
          return
        end

        local is_insert_mode = function()
          return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
        end
        local confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }
        if is_insert_mode() then
          confirm_opts.behavior = cmp.ConfirmBehavior.Insert
        end
        if not cmp.confirm(confirm_opts) then
          fallback()
        end
      end

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
          { name = "calc", group_index = 5 },
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
              cmp.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true }
            else
              fallback()
            end
          end, { "i", "s" }),
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
            require("clangd_extensions.cmp_scores"),
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
  },
}
