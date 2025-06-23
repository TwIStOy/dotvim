---@module "dotvim.plugins.copilot"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    enabled = not vim.g.vscode,
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
      local setup = function(node_path)
        opts.copilot_node_command = node_path
        require("copilot").setup(opts)

        -- Store current status for lualine component
        local current_status = { status = "", message = "" }

        -- Register status handler for lualine
        local status_mod = require("copilot.status")
        status_mod.register_status_notification_handler(function(data)
          current_status = data
          pcall(require("lualine").refresh)
        end)

        -- Global status getter for lualine
        _G.dotvim_copilot_get_status = function()
          return current_status.status or ""
        end
      end

      vim.defer_fn(function()
        local node_path = vim.fn.exepath("node")
        
        if node_path and node_path ~= "" then
          setup(node_path)
        else
          -- Try to get node from fish shell
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
            end
          end)
        end
      end, 100)
    end,
  },
  {
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
      model = "claude-sonnet-4",
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
        desc = "toggle-copilot-chat",
      },
    },
  },
}
