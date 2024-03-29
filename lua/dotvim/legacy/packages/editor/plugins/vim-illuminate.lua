---@type dora.core.plugin.PluginOption[]
return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      filetypes_denylist = {
        "nuipopup",
        "rightclickpopup",
        "NvimTree",
        "help",
      },
    },
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
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "vim-illuminate",
        category = "Illuminate",
        actions = {
          {
            id = "illuminate.pause",
            callback = "IlluminatePause",
            title = "Globally pause vim-illuminate",
          },
          {
            id = "illuminate.resume",
            callback = "IlluminateResume",
            title = "Globally resume vim-illuminate",
          },
          {
            id = "illuminate.toggle",
            callback = "IlluminateToggle",
            title = "Globally toggle the pause/resume for vim-illuminate",
          },
          {
            id = "illuminate.pause_buf",
            callback = "IlluminatePauseBuf",
            title = "Buffer-local pause of vim-illuminate",
          },
          {
            id = "illuminate.resume_buf",
            callback = "IlluminateResumeBuf",
            title = "Buffer-local resume of vim-illuminate",
          },
          {
            id = "illuminate.toggle_buf",
            callback = "IlluminateToggleBuf",
            title = "Buffer-local toggle of the pause/resume for vim-illuminate",
          },
          {
            id = "illuminate.freeze",
            callback = function()
              require("illuminate").freeze_buf()
            end,
            title = "Freeze the illumination on the buffer, this won't clear the highlights",
          },
          {
            id = "illuminate.unfreeze",
            callback = function()
              require("illuminate").unfreeze_buf()
            end,
            title = "Unfreeze the illumination on the buffer",
          },
          {
            id = "illuminate.toggle_freeze",
            callback = function()
              require("illuminate").toggle_freeze_buf()
            end,
            title = "Toggle the frozen state of the buffer",
          },
        },
      }
    end,
  },
}
