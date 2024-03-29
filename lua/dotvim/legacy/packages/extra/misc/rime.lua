local just_inserted = false

---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.rime",
  deps = {
    "dora.packages.coding",
    "dora.packages.lsp",
  },
  plugins = {
    {
      "nvim-lspconfig",
      opts = function(_, opts)
        require("lspconfig.configs").rime_ls = {
          default_config = {
            name = "rime_ls",
            cmd = { "rime_ls" },
            filetypes = { "markdown", "text" },
            single_file_support = true,
          },
          settings = {},
          docs = {
            description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
          },
        }

        opts.servers.opts.rime_ls = {
          init_options = {
            enabled = false,
            shared_data_dir = "~/.local/share/rime-ls-data-files",
            user_data_dir = "~/.local/share/rime-ls-files",
            log_dir = "~/.local/share/rime-ls-files/log",
            max_candidates = 9,
            trigger_characters = {},
            schema_trigger_character = "&",
            max_tokens = 4,
            override_server_capabilities = { trigger_characters = {} },
            always_incomplete = true,
          },
        }

        ---@type dora.lib
        local lib = require("dora.lib")

        local function is_rime_entry(entry)
          return vim.tbl_get(entry, "source", "name") == "nvim_lsp"
            and vim.tbl_get(entry, "source", "source", "client", "name")
              == "rime_ls"
        end

        local function text_edit_range_length(entry)
          local range = entry.completion_item.textEdit.range
          return range["end"].character - range.start.character
        end

        local rime_ls_auto_confirm = vim.schedule_wrap(function()
          local cmp = require("cmp")
          if not vim.g.global_rime_enabled or not cmp.visible() then
            return
          end
          local entries = cmp.core.view:get_entries()
          if entries == nil or #entries == 0 then
            return
          end
          local rime_ls_entries_cnt = 0
          for _, entry in ipairs(entries) do
            if is_rime_entry(entry) then
              rime_ls_entries_cnt = rime_ls_entries_cnt + 1
            end
          end
          local first_entry = cmp.get_selected_entry()
          if first_entry == nil then
            first_entry = cmp.core.view:get_first_entry()
          end
          if
            first_entry ~= nil
            and rime_ls_entries_cnt == 1
            and is_rime_entry(first_entry)
            and text_edit_range_length(first_entry) == 4
          then
            cmp.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }
          end
        end)

        opts.servers.setup.rime_ls = function(_, server_opts)
          vim.g.global_rime_enabled = server_opts.init_options.enabled or false

          require("lspconfig").rime_ls.setup(server_opts)

          lib.vim.on_lsp_attach(function(client, bufnr)
            local toggle_rime = function()
              client.request(
                "workspace/executeCommand",
                { command = "rime-ls.toggle-rime" },
                function(_, result, ctx, _)
                  if ctx.client_id == client.id then
                    vim.g.global_rime_enabled = not not result
                  end
                end,
                bufnr
              )
            end

            vim.keymap.set({ "n", "i" }, "<M-;>", function()
              toggle_rime()
            end, {
              silent = true,
              desc = "rime-toggle",
              buffer = bufnr,
            })

            local ft = vim.api.nvim_get_option_value("filetype", {
              buf = bufnr,
            })

            if ft == "markdown" then
              local toggle_markdown_code = function()
                if vim.g.previous_markdown_code ~= nil then
                  if
                    vim.g.previous_markdown_code ~= vim.g.global_rime_enabled
                  then
                    toggle_rime()
                  end
                  vim.g.previous_markdown_code = nil
                else
                  vim.g.previous_markdown_code = vim.g.global_rime_enabled
                  if vim.g.global_rime_enabled then
                    toggle_rime()
                  end
                end
              end

              vim.keymap.set({ "i" }, "`", function()
                toggle_markdown_code()
                vim.fn.feedkeys("`", "n")
              end, {
                silent = true,
                desc = "rime-toggle",
                buffer = bufnr,
              })
            end

            vim.keymap.set("n", "<leader>rs", function()
              vim.lsp.buf.execute_command { command = "rime-ls.sync-user-data" }
            end, { desc = "rime-sync-user-data", buffer = bufnr })

            vim.api.nvim_create_autocmd("InsertCharPre", {
              buffer = bufnr,
              callback = function()
                just_inserted = true
              end,
            })
            vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
              buffer = bufnr,
              callback = function()
                if just_inserted then
                  -- check completion
                  rime_ls_auto_confirm()
                  just_inserted = false
                end
              end,
            })
          end)
        end
      end,
    },
    {
      "nvim-cmp",
      opts = function(_, opts)
        local cmp = require("cmp")

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

        opts.mapping["<CR>"] = i_cr_action
        opts.mapping["<Space>"] = cmp.mapping(function(fallback)
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
        end, { "i", "s" })
      end,
    },
  },
}
