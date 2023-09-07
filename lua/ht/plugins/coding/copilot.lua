return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    event = "InsertEnter",
    config = function()
      -- get current node instance
      local node_path = vim.fn.system('fish -c "which node"')
      node_path = node_path:match("^%s*(.-)%s*$")

      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          },
        },
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

      local RC = require("ht.core.right-click")
      RC.add_section {
        index = RC.indexes.copilot,
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
