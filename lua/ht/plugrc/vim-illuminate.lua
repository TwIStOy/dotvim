return {
  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = { delay = 200, filetypes_denylist = { 'nuipopup' } },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
          pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
        end,
      })

      local function t_cmd(title, cmd)
        return {
          title = title,
          f = function()
            vim.cmd(cmd)
          end,
        }
      end

      require 'ht.core.functions':add_function_set{
        category = "Illuminate",
        functions = {
          t_cmd("Globally pause vim-illuminate", "IlluminatePause"),
          t_cmd("Globally resume vim-illuminate", "IlluminateResume"),
          t_cmd("Globally toggle the pause/resume for vim-illuminate",
                "IlluminateToggle"),
          t_cmd("Buffer-local pause of vim-illuminate", "IlluminatePauseBuf"),
          t_cmd("Buffer-local resume of vim-illuminate", "IlluminateResumeBuf"),
          t_cmd("Buffer-local toggle of the pause/resume for vim-illuminate",
                "IlluminateToggleBuf"),
          {
            title = "Freeze the illumination on the buffer, this won't clear the highlights",
            f = function()
              require('illuminate').freeze_buf()
            end,
          },
          {
            title = "Unfreeze the illumination on the buffer",
            f = function()
              require('illuminate').unfreeze_buf()
            end,
          },
          {
            title = "Toggle the frozen state of the buffer",
            f = function()
              require('illuminate').toggle_freeze_buf()
            end,
          },
        },
      }
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },
}
