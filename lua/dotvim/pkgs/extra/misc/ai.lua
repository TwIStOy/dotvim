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

          -- Setup Copilot with our options
          require("copilot").setup(opts)
          _copilot_setup_done = true

          -- Store current status for our lualine component without triggering notifications
          local current_status = { status = "", message = "" }

          -- Register our handler to refresh lualine when status changes
          local status_mod = require("copilot.status")
          status_mod.register_status_notification_handler(function(data)
            current_status = data
            pcall(require("lualine").refresh)
          end)

          -- Store the get_status function as a global that doesn't trigger notifications
          _G.dotvim_copilot_get_status = function()
            -- Get current data without calling status() which would trigger notifications
            return current_status.status or ""
          end
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
      branch = "main",
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
        model = "claude-3.5-sonnet",
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

        -- Replace is_current_buffer_attached and is_enabled with new API
        local function is_enabled()
          if not _copilot_setup_done then
            return false
          end
          -- Check if Copilot LSP client is attached to the current buffer
          local clients = vim.lsp.get_clients { bufnr = 0 }
          for _, client in ipairs(clients) do
            if client.name == "copilot" then
              return true
            end
          end
          return false
        end

        ---@return 'Disabled' | 'Error' | 'InProgress' | 'Sleeping' | 'Normal'
        local function copilot_status()
          if not _copilot_setup_done then
            return "InProgress"
          end
          if not is_enabled() then
            return "Disabled"
          end

          -- Use the global getter function that doesn't trigger notifications
          -- instead of directly calling status_mod.status()
          local status = ""
          if _G.dotvim_copilot_get_status then
            status = _G.dotvim_copilot_get_status()
          end

          -- Try to be robust to possible new/changed status values
          if status == "Warning" or status == "Error" then
            return "Error"
          elseif status == "InProgress" or status == "Processing" then
            return "InProgress"
          elseif status == "Normal" or status == "Enabled" then
            -- check for sleeping/idle
            local suggestion_ok, suggestion =
              pcall(require, "copilot.suggestion")
            if
              suggestion_ok
              and suggestion.is_auto_trigger
              and not suggestion.is_auto_trigger()
            then
              return "Sleeping"
            end
            return "Normal"
          elseif status == "Disabled" then
            return "Disabled"
          elseif status == "Idle" or status == "Sleeping" then
            return "Sleeping"
          end
          return status or "Normal"
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
              -- No longer register handler here, just refresh lualine
              pcall(require("lualine").refresh)
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

        table.insert(opts.sections.lualine_y, 1, component)
      end,
    },
    {
      "lualine.nvim",
      opts = function(_, opts)
        local M = require("lualine.component"):extend()

        M.processing = false
        M.spinner_index = 1

        local spinner_symbols = {
          "⠋",
          "⠙",
          "⠹",
          "⠸",
          "⠼",
          "⠴",
          "⠦",
          "⠧",
          "⠇",
          "⠏",
        }
        local spinner_symbols_len = 10

        -- Initializer
        function M:init(options)
          M.super.init(self, options)

          local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

          vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequest*",
            group = group,
            callback = function(request)
              if request.match == "CodeCompanionRequestStarted" then
                self.processing = true
              elseif request.match == "CodeCompanionRequestFinished" then
                self.processing = false
              end
            end,
          })
        end

        -- Function that runs every time statusline is updated
        function M:update_status()
          if self.processing then
            self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
            return spinner_symbols[self.spinner_index]
          else
            return nil
          end
        end

        table.insert(opts.sections.lualine_c, M)
      end,
    },
    {
      "olimorris/codecompanion.nvim",
      enabled = true,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      lazy = true,
      cmd = {
        "CodeCompanion",
        "CodeCompanionChat",
        "CodeCompanionActions",
      },
      config = function(_, opts)
        require("codecompanion").setup(opts)
        vim.g.codecompanion_auto_tool_mode = true
      end,
      opts = {
        opts = {
          log_level = "DEBUG",
        },
        display = {
          chat = {
            show_settings = true,
          },
        },
        strategies = {
          chat = {
            adapter = "copilot",
            tools = {
              ["mcp"] = {
                callback = function()
                  vim.wait(5000, function()
                    return require("mcphub").get_hub_instance() ~= nil
                  end)
                  return require("mcphub.extensions.codecompanion")
                end,
                description = "Call tools and resources from the MCP Servers",
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.7-sonnet-thought",
                },
                max_tokens = {
                  default = 900000,
                },
              },
            })
          end,
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              url = "https://api.luee.net/v1/messages",
              env = {
                api_key = "cmd:cat /run/agenix/luee-net-api-key",
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                url = "https://api.gptsapi.net/v1/",
                api_key = "cmd:cat /run/agenix/wildcard-api-key",
              },
            })
          end,
        },
      },
    },
    {
      "ravitemer/mcphub.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      cmd = "MCPHub",
      build = "bundled_build.lua",
      lazy = true,
      config = function()
        require("mcphub").setup {
          auto_approve = true,
          use_bundled_binary = true,
          extensions = {
            codecompanion = {
              show_result_in_chat = false,
              make_vars = true,
              make_slash_commands = true,
            },
            avante = {
              make_slash_commands = true,
            },
          },
        }
      end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      build = "make",
      pname = "avante-nvim",
      enabled = true,
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
        copilot = {
          model = "claude-3.7-sonnet-thought",
        },
        disabled_tools = {
          "list_files",
          "search_files",
          "read_file",
          "create_file",
          "rename_file",
          "delete_file",
          "create_dir",
          "rename_dir",
          "delete_dir",
          "bash",
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
        system_prompt = function()
          vim.wait(5000, function()
            return require("mcphub").get_hub_instance() ~= nil
          end)
          local hub = require("mcphub").get_hub_instance()
          return hub:get_active_servers_prompt()
        end,
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
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
