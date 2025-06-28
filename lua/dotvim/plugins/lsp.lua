---@module "dotvim.plugins.lsp"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    priority = 1000,
    enabled = not vim.g.vscode,
    opts = {
      preset = "amongus",
      options = {
        show_source = {
          enabled = true,
          if_many = true,
        },
        overwrite_events = { "BufEnter", "LspAttach" },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.diagnostic.config { virtual_text = false }
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = function()
      return not Commons.nix.in_nix_env() and not vim.g.vscode
    end,
    opts = function(_, opts)
      return Commons.option.deep_merge(opts, {
        PATH = "append",
        ui = {
          icons = {
            package_installed = " ",
            package_pending = " ",
            package_uninstalled = " ",
          },
        },
        extra = {
          outdated_check_interval = 1, -- in days
          ensure_installed = {
            "gh",
          },
          update_installed_packages = true,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function(_, opts)
      for lsp, config in pairs(opts.lsp_configs or {}) do
        vim.lsp.config(lsp, config)

        -- Try to replace cmd in the final merged config using Commons.which
        local final_config = vim.lsp.config[lsp]
        if
          final_config
          and final_config.cmd
          and type(final_config.cmd) == "table"
          and #final_config.cmd > 0
        then
          local resolved_cmd = Commons.which(final_config.cmd[1])
          if resolved_cmd then
            local new_cmd = vim.deepcopy(final_config.cmd)
            new_cmd[1] = resolved_cmd
            final_config.cmd = new_cmd

            -- Merge the final config to update cmd if necessary
            vim.lsp.config(lsp, final_config)
          end
        end

        vim.lsp.enable(lsp)
      end
    end,
  },
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      {
        "<leader>fo",
        function()
          local Outline = require("outline")
          ---@diagnostic disable-next-line: undefined-field
          if Outline.is_open() then
            ---@diagnostic disable-next-line: undefined-field
            Outline.focus_outline()
          else
            ---@diagnostic disable-next-line: undefined-field
            Outline.open_outline()
            ---@diagnostic disable-next-line: undefined-global
            vim.schedule(function()
              ---@diagnostic disable-next-line: undefined-field
              Outline.focus_outline()
            end)
          end
        end,
        desc = "focus-outline",
      },
    },
    config = function(_, opts)
      local Outline = require("outline")
      ---@diagnostic disable-next-line: undefined-field
      Outline.setup(opts)

      local outline_follow = Commons.fn.throttle(2000, function()
        ---@diagnostic disable-next-line: undefined-field
        Outline.follow_cursor {
          focus_outline = false,
        }
      end)

      local outline_refresh = Commons.fn.throttle(2000, function()
        ---@diagnostic disable-next-line: undefined-field
        Outline.refresh()
      end)

      ---@diagnostic disable-next-line: undefined-global
      vim.api.nvim_create_autocmd({
        "InsertLeave",
        "WinEnter",
        "BufEnter",
        "BufWinEnter",
        "TabEnter",
        "BufWritePost",
      }, {
        pattern = "*",
        callback = function()
          outline_refresh()
        end,
      })

      ---@diagnostic disable-next-line: undefined-global
      vim.api.nvim_create_autocmd("CursorMoved", {
        pattern = "*",
        callback = function()
          outline_follow()
        end,
      })
    end,
    opts = {
      keymaps = {
        show_help = "?",
        close = {},
        goto_location = "<Cr>",
        peek_location = "o",
        goto_and_close = {},
        restore_location = "<C-g>",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = {},
        unfold = {},
        fold_toggle = "<Tab>",
        fold_toggle_all = "<S-Tab>",
        fold_all = {},
        unfold_all = "E",
        fold_reset = "R",
        down_and_jump = "<C-j>",
        up_and_jump = "<C-k>",
      },
      outline_window = {
        winhl = "Normal:NormalFloat",
      },
      outline_items = {
        auto_update_events = {
          follow = {},
          items = {},
        },
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
        },
      },
      providers = {
        lsp = {
          blacklist_clients = {
            "copilot",
          },
        },
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = function()
      local actions = require("glance").actions
      return {
        detached = function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end,
        preview_win_opts = { cursorline = true, number = true, wrap = false },
        border = { disable = true, top_char = "―", bottom_char = "―" },
        theme = { enable = true },
        list = { width = 0.2 },
        mappings = {
          list = {
            ["j"] = actions.next,
            ["k"] = actions.previous,
            ["<Down>"] = false,
            ["<Up>"] = false,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = false,
            ["s"] = false,
            ["t"] = false,
            ["<CR>"] = actions.jump,
            ["o"] = false,
            ["<leader>l"] = false,
            ["q"] = actions.close,
            ["Q"] = actions.close,
            ["<Esc>"] = actions.close,
          },
          preview = {
            ["Q"] = actions.close,
            ["<Tab>"] = false,
            ["<S-Tab>"] = false,
            ["<leader>l"] = false,
          },
        },
        folds = { fold_closed = "󰅂", fold_open = "󰅀", folded = false },
        indent_lines = { enable = false },
        winbar = { enable = true },
        hooks = {
          before_open = function(results, open, jump, method)
            if method == "references" or method == "implementations" then
              open(results)
            elseif #results == 1 then
              jump(results[1])
            else
              open(results)
            end
          end,
        },
      }
    end,
  },
}
