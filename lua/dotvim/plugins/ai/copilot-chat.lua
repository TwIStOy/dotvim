---@type LazyPluginSpec
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled = not vim.g.vscode,
  branch = "main",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
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
    model = "gpt-5",
    window = {
      layout = "vertical",
      width = 0.5,
    },
    headers = {
      user = "👤 You",
      assistant = "🤖 Copilot",
      tool = "🔧 Tool",
    },
  },
  keys = {
    {
      "<C-g>",
      function()
        vim.cmd("CopilotChatToggle")
      end,
      desc = "toggle-copilot-chat",
    },
  },
}
