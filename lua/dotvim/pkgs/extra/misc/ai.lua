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
      cmd = { "Copilot" },
      config = function(_, opts)
        local setup = function(path)
          opts.copilot_node_command = path
          require("copilot").setup(opts)
          _copilot_setup_done = true
        end

        vim.defer_fn(function()
          ---@type dotvim.utils
          local Utils = require("dotvim.utils")

          local node_path = Utils.which("node", false)
          if node_path == nil then
            -- try to get node from fish shell
            vim.system({
              "fish",
              "-c",
              "which node",
            }, {
              text = true,
            }, function(obj)
              if obj.code == 0 then
                local path = vim.trim(obj.stdout)
                vim.schedule(function()
                  setup(path)
                end)
              else
                vim.notify("Node not found", vim.log.levels.ERROR)
                vim.notify(obj.stdout, vim.log.levels.ERROR)
                vim.notify(obj.stderr, vim.log.levels.ERROR)
              end
            end)
          else
            setup(node_path)
          end
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
        "CopilotChatStop",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatDebugInfo",
        "CopilotChatModels",
        "CopilotChatModel",
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
      opts = {
        model = "gpt-4o",
        window = {
          layout = "float",
          width = 0.8,
          height = 0.8,
        },
      },
      keys = {
        {
          "<C-g>",
          function()
            vim.cmd("CopilotChatToggle")
          end,
        },
      },
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
      "yetone/avante.nvim",
      event = "VeryLazy",
      build = "make",
      pname = "avante-nvim",
      opts = {
        provider = "copilot",
        openai = {
          endpoint = "https://api.gptsapi.net/v1/",
          api_key_name = "cmd:cat /run/agenix/wildcard-api-key",
        },
        claude = {
          endpoint = "https://api.luee.net",
          api_key_name = "cmd:cat /run/agenix/luee-net-api-key",
        },
        mappings = {
          ask = "<leader>aa",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          diff = {
            ours = "co",
            theirs = "ct",
            both = "cb",
            next = "]x",
            prev = "[x",
          },
          jump = {
            next = "]d",
            prev = "[d",
          },
          submit = {
            normal = "<CR>",
            insert = "<C-CR>",
          },
          toggle = {
            debug = "<leader>ad",
            hint = "<leader>ah",
          },
        },
        hints = { enabled = true },
        windows = {
          wrap = true, -- similar to vim.o.wrap
          width = 30, -- default % based on available width
          sidebar_header = {
            align = "center", -- left, center, right for title
            rounded = true,
          },
        },
        highlights = {
          diff = {
            current = "DiffText",
            incoming = "DiffAdd",
          },
        },
        --- @class AvanteConflictUserConfig
        diff = {
          debug = false,
          autojump = true,
          ---@type string | fun(): any
          list_opener = "copen",
        },
      },
      config = function(_, opts)
        require("avante_lib").load()
        require("avante").setup(opts)
      end,
      dependencies = {
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
      },
    },
  },
}
