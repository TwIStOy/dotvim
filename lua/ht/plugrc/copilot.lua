return {
  Use {
    "jcdickinson/codeium.nvim",
    lazy = {
      dependencies = { "jcdickinson/http.nvim", "nvim-lua/plenary.nvim" },
      enabled = true,
      lazy = true,
      config = function()
        require("codeium").setup {}
      end,
      cmd = {
        "Codeium",
      },
    },
    functions = { FuncSpec("Codeium auth", "Codeium Auth") },
  },

  {
    "zbirenbaum/copilot-cmp",
    lazy = true,
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    keys = {
      {
        "<M-a>",
        function()
          require("copilot.suggestion").accept()
        end,
        mode = "i",
        desc = "accept-copilot-suggestion",
      },
    },
    config = function()
      -- get current node instance
      local node_path = vim.fn.system('fish -c "which node"')
      node_path = node_path:match("^%s*(.-)%s*$")

      require("copilot").setup {
        suggestion = { accept = "<M-a>" },
        copilot_node_command = node_path,
      }

      local function toggle_auto_trigger()
        require("copilot.suggestion").toggle_auto_trigger()

        local cmp = require("cmp")
        cmp.event:on("menu_opened", function()
          vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end

      require("ht.core.functions"):add_function_set {
        category = "Copilot",
        functions = {
          {
            title = "Copilot status",
            f = function()
              vim.api.nvim_command([[Copilot status]])
            end,
          },
          {
            title = "Copilot Auth",
            f = function()
              vim.api.nvim_command([[Copilot auth]])
            end,
          },
          {
            title = "Copilot Panel",
            f = function()
              vim.api.nvim_command([[Copilot panel]])
            end,
          },
          { title = "Copilot Toggle Auto Trigger", f = toggle_auto_trigger },
        },
      }

      require("ht.core.right-click").add_section {
        index = 5,
        enabled = {
          others = function(_, ft, _)
            return ft ~= nil and ft ~= "NvimTree"
          end,
        },
        items = {
          {
            "Copilot",
            children = {
              {
                "Status",
                callback = function()
                  vim.api.nvim_command([[Copilot status]])
                end,
              },
              {
                "Auth",
                callback = function()
                  vim.api.nvim_command([[Copilot auth]])
                end,
              },
              {
                "Panel",
                callback = function()
                  vim.api.nvim_command([[Copilot panel]])
                end,
              },
              { "Toggle Auto Trigger", callback = toggle_auto_trigger },
            },
          },
        },
      }
    end,
  },
}
