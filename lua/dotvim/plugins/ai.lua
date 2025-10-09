return {
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    opts = {
      -- Flat opts structure (not nested)
      opts = {
        log_level = "ERROR", -- Changed from nested structure
      },
      memory = {
        opts = {
          chat = {
            condition = function(chat)
              return chat.adapter.type ~= "acp"
            end,
          },
        },
      },
      display = {
        chat = {
          show_settings = true,
        },
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
      -- Extensions configuration (new style)
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = false,
            make_vars = true,
            make_slash_commands = true,
          },
        },
        spinner = {},
      },
      prompt_library = {
        ["Beast Mode"] = (function()
          local beast_mode = require("dotvim.configs.beast-mode-prompt")
          return {
            strategy = "chat",
            description = "Autonomous agent with extensive research and todo list capabilities",
            opts = {
              short_name = "beast",
              is_slash_cmd = true,
              auto_submit = false,
            },
            prompts = {
              {
                role = "system",
                content = beast_mode.system_prompt,
              },
              {
                role = "user",
                content = beast_mode.user_prompt(),
              },
            },
          }
        end)(),
        ["Code Review"] = {
          strategy = "chat",
          description = "Code review assistant",
          opts = {
            short_name = "review",
            is_slash_cmd = true,
            auto_submit = true,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = require("dotvim.configs.prompts.copilot-review").system_prompt,
            },
            {
              role = "user",
              content = require("dotvim.configs.prompts.copilot-review").user_prompt,
            },
          },
        },
      },
      adapters = {
        http = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  -- default = "claude-sonnet-4",
                  default = "gpt-5",
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
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.g.codecompanion_auto_tool_mode = true
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua",
    lazy = false,
    config = function()
      require("mcphub").setup {
        auto_approve = true,
        config = os.getenv("HOME") .. "/.dotvim/mcp-servers.json",
        use_bundled_binary = true,
        extensions = {
          copilotchat = {
            enabled = true,
            convert_tools_to_functions = true,
            convert_resources_to_functions = true,
            add_mcp_prefix = false,
          },
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
    "folke/sidekick.nvim",
    opts = {
      mux = {
        backend = "tmux",
      },
    },
    event = "VeryLazy",
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
    },
  },
}
