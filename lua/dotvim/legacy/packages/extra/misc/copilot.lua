local _copilot_setup_done = false

---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.misc.copilot",
  deps = {
    "dora.packages.coding",
    "dora.packages.ui",
  },
  plugins = {
    {
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          },
        },
      },
      config = function(_, opts)
        vim.defer_fn(function()
          require("copilot").setup(opts)
          _copilot_setup_done = true
        end, 100)
      end,
      actions = function()
        return {
          {
            id = "copilot.status",
            title = "Copilot status",
            description = "Show the status of Copilot",
            callback = function()
              vim.api.nvim_command("Copilot status")
            end,
          },
          {
            id = "copilot.auth",
            title = "Copilot auth",
            callback = function()
              vim.api.nvim_command("Copilot auth")
            end,
          },
          {
            id = "copilot.show-panel",
            title = "Copilot panel",
            callback = function()
              vim.api.nvim_command("Copilot panel")
            end,
          },
        }
      end,
    },
    {
      "lualine.nvim",
      opts = function(_, opts)
        local spinners = {
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
        }
        local normal_icon = " "
        local disable_icon = " "
        local warning_icon = " "
        local sleeping_icon = "󰒲 "

        local function hl_fg(name)
          local hl = vim.api.nvim_get_hl(0, {
            name = name,
            link = false,
          })
          local fg = hl.fg
          if fg ~= nil and fg ~= "" then
            return string.format("#%x", fg)
          end
          return ""
        end

        local is_current_buffer_attached = function()
          if not _copilot_setup_done then
            return false
          end
          return require("copilot.client").buf_is_attached(
            vim.api.nvim_get_current_buf()
          )
        end

        local function is_enabled()
          if not _copilot_setup_done then
            return false
          end

          if require("copilot.client").is_disabled() then
            return false
          end

          if not is_current_buffer_attached() then
            return false
          end

          return true
        end

        ---@return 'Disabled' | 'Error' | 'InProgress' | 'Sleeping' | 'Normal'
        local function copilot_status()
          if not _copilot_setup_done then
            return "InProgress"
          end
          if not is_enabled() then
            return "Disabled"
          end
          local data = require("copilot.api").status.data.status
          if data == "Warning" then
            return "Error"
          elseif data == "InProgress" then
            return "InProgress"
          end
          if vim.b.copilot_suggestion_auto_trigger == nil then
            if not require("copilot.config").get("suggestion").auto_trigger then
              return "Sleeping"
            end
            return "Normal"
          else
            if not vim.b.copilot_suggestion_auto_trigger then
              return "Sleeping"
            end
            return "Normal"
          end
        end

        ---@type dora.lib
        local lib = require("dora.lib")

        local spinner_count = 1

        local component = require("lualine.component"):extend()

        local highlight = require("lualine.highlight")

        function component:init(options)
          component.super:init(options)
          lib.vim.on_lsp_attach(function(client, _)
            if client and client.name == "copilot" then
              require("copilot.api").register_status_notification_handler(
                function()
                  require("lualine").refresh()
                end
              )
              return true
            end
            return false
          end)
          self.error_hl = highlight.create_component_highlight_group({
            {
              fg = hl_fg("DiagnosticError"),
            },
          }, "copilot_lualine_error", options)
          self.in_progress_hl = highlight.create_component_highlight_group({
            {
              fg = hl_fg("DiagnosticHint"),
            },
          }, "copilot_lualine_in_progress", options)
          self.sleeping_hl = highlight.create_component_highlight_group({
            {
              fg = hl_fg("Comment"),
            },
          }, "copilot_lualine_sleeping", options)
        end

        function component:update_status()
          local status = copilot_status()
          if status == "Normal" then
            return normal_icon
          elseif status == "Disabled" then
            return disable_icon
          elseif status == "Error" then
            return highlight.component_format_highlight(self.error_hl)
              .. warning_icon
          elseif status == "InProgress" then
            local icon = spinners[spinner_count]
            spinner_count = (spinner_count + 1) % #spinners + 1
            return highlight.component_format_highlight(self.in_progress_hl)
              .. icon
          elseif status == "Sleeping" then
            return highlight.component_format_highlight(self.sleeping_hl)
              .. sleeping_icon
          else
            return normal_icon
          end
        end

        table.insert(opts.sections.lualine_y, 1, component)
      end,
    },
  },
}
