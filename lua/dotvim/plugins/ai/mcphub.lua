---@type LazyPluginSpec
return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "bundled_build.lua",
  lazy = true,
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
}
