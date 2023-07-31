return {
  {
    "jbyuki/nabla.nvim",
    lazy = true,
    ft = { "latex", "markdown" },
    config = function()
      local show_nabla = function()
        local nabla = require("nabla")
        nabla.popup {
          border = "solid",
        }
      end
      ---@param ev vim.AutocmdCallback.Event?
      local setup_keymap = function(ev)
        local buf = 0
        if ev then
          buf = ev.buf
        end

        vim.keymap.set("n", "<leader>pf", show_nabla, {
          desc = "Preview formula",
          buffer = buf,
        })
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "latex",
          "markdown",
        },
        callback = setup_keymap,
      })
      local ft = vim.api.nvim_get_option_value("ft", {
        buf = 0,
      })
      if ft == "latex" or ft == "markdown" then
        setup_keymap()
      end
    end,
  },
}
