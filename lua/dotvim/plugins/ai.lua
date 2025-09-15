---@type LazyPluginSpec[]
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
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.g.codecompanion_auto_tool_mode = true
    end,
    opts = {
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
              ignore_system_prompt = true,
              adapter = {
                name = "copilot",
                model = "claude-sonnet-4",
              },
            },
            prompts = {
              {
                role = "system",
                content = beast_mode.system_prompt,
              },
              {
                role = "user",
                content = beast_mode.user_prompt,
              },
            },
          }
        end)(),
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-sonnet-4",
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
    cmd = "MCPHub",
    build = "bundled_build.lua",
    lazy = true,
    config = function()
      require("mcphub").setup {
        auto_approve = true,
        config = os.getenv("HOME") .. "/.dotvim/mcp-servers.json",
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
}
