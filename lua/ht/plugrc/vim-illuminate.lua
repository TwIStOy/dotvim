return {
  -- references
  {
    "RRethy/vim-illuminate",
    category = "Illuminate",
    functions = {
      FuncSpec("Globally pause vim-illuminate", "IlluminatePause"),
      FuncSpec("Globally resume vim-illuminate", "IlluminateResume"),
      FuncSpec("Globally toggle the pause/resume for vim-illuminate",
               "IlluminateToggle"),
      FuncSpec("Buffer-local pause of vim-illuminate", "IlluminatePauseBuf"),
      FuncSpec("Buffer-local resume of vim-illuminate", "IlluminateResumeBuf"),
      FuncSpec("Buffer-local toggle of the pause/resume for vim-illuminate",
               "IlluminateToggleBuf"),
      FuncSpec(
          "Freeze the illumination on the buffer, this won't clear the highlights",
          function()
            require('illuminate').freeze_buf()
          end),
      FuncSpec("Unfreeze the illumination on the buffer", function()
        require('illuminate').unfreeze_buf()
      end),
      FuncSpec("Toggle the frozen state of the buffer", function()
        require('illuminate').toggle_freeze_buf()
      end),
    },
    lazy = {
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
  },
}
