return {
  Use {
    "rest-nvim/rest.nvim",
    lazy = {
      opts = {
        skip_ssl_verification = true,
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function(_, opts)
        require("rest-nvim").setup(opts)

        local right_click_items = {
          {
            "Http",
            children = {
              {
                "Run the request under cursor",
                callback = function()
                  require("rest-nvim").run()
                end,
                keys = "r",
              },
              {
                "Preview the request cURL command",
                callback = function()
                  require("rest-nvim").run(true)
                end,
                keys = "p",
              },
              {
                "Rerun the last command",
                callback = function()
                  require("rest-nvim").last()
                end,
                keys = "l",
              },
            },
            keys = "t",
          },
        }

        local RC = require("ht.core.right-click")
        RC.add_section {
          index = RC.indexes.http,
          enabled = {
            filetype = {
              "http",
            },
          },
          items = right_click_items,
        }
      end,
    },
    functions = {
      {
        filter = {
          filter = function(buffer)
            if buffer.filename == nil then
              return false
            end
            return buffer.filename:match(".*%.http") ~= nil
          end,
        },
        values = {
          FuncSpec("Run the request under cursor", function()
            require("rest-nvim").run()
          end),
          FuncSpec("Preview the request cURL command", function()
            require("rest-nvim").run(true)
          end),
          FuncSpec("Rerun the last command", function()
            require("rest-nvim").last()
          end),
        },
      },
    },
  },
}
