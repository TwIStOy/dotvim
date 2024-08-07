local _copilot_setup_done = false

---@type dotvim.core.package.PackageOption
return {
  name = "extra.misc.ai",
  deps = {
    "coding",
    "editor",
    "ui",
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
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
        "copilot.lua",
        "plenary.nvim",
      },
      cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatDebugInfo",
        "CopilotChatExplain",
        "CopilotChatReview",
        "CopilotChatFix",
        "CopilotChatOptimize",
        "CopilotChatDocs",
        "CopilotChatTests",
        "CopilotChatFixDiagnostic",
        "CopilotChatCommit",
        "CopilotChatCommitStaged",
      },
      opts = {},
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

        ---@type dotvim.core
        local Core = require("dotvim.core")

        local spinner_count = 1

        local component = require("lualine.component"):extend()

        local highlight = require("lualine.highlight")

        function component:init(options)
          component.super:init(options)
          Core.lsp.on_lsp_attach(function(client, _)
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
          self.current_icon = spinners[1]
        end

        ---@type dotvim.utils
        local Utils = require("dotvim.utils")
        local update_status = Utils.fn.throttle(1000, function(self)
          local status = copilot_status()
          if status == "Normal" then
            self.current_icon = normal_icon
          elseif status == "Disabled" then
            self.current_icon = disable_icon
          elseif status == "Error" then
            self.current_icon = highlight.component_format_highlight(
              self.error_hl
            ) .. warning_icon
          elseif status == "InProgress" then
            local icon = spinners[spinner_count]
            spinner_count = (spinner_count + 1) % #spinners + 1
            self.current_icon = highlight.component_format_highlight(
              self.in_progress_hl
            ) .. icon
          elseif status == "Sleeping" then
            self.current_icon = highlight.component_format_highlight(
              self.sleeping_hl
            ) .. sleeping_icon
          else
            self.current_icon = normal_icon
          end
        end)

        function component:update_status()
          update_status(self)
          return self.current_icon
        end

        -- table.insert(opts.sections.lualine_y, 1, component)
      end,
    },
    {
      "David-Kunz/gen.nvim",
      cmd = "Gen",
      opts = {
        model = "mistral", -- The default model to use.
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        quit_map = "q",
        retry_map = "<c-r>",
        init = function() end, -- do nothing!
        display_mode = "float", -- The display mode. Can be "float" or "split".
        show_prompt = false, -- Shows the prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        debug = false, -- Prints errors and the command which is run.
      },
    },
  },
}
