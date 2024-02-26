local lib = require("dora.lib")

---@type dora.lib.PluginOptions
return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  gui = "all",
  opts = function(_, opts)
    opts = opts or {}
    return vim.tbl_deep_extend("keep", opts, {
      delay = 200,
      filetypes_denylist = {
        "nuipopup",
        "rightclickpopup",
        "NvimTree",
        "help",
      },
    })
  end,
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
  actions = lib.plugin.action.make_options {
    from = "vim-illuminate",
    category = "Illuminate",
    ---@type dora.lib.ActionOptions[]
    actions = {
      {
        id = "illuminate.pause",
        callback = "IlluminatePause",
        desc = "Globally pause vim-illuminate",
      },
      {
        id = "illuminate.resume",
        callback = "IlluminateResume",
        desc = "Globally resume vim-illuminate",
      },
      {
        id = "illuminate.toggle",
        callback = "IlluminateToggle",
        desc = "Globally toggle the pause/resume for vim-illuminate",
      },
      {
        id = "illuminate.pause_buf",
        callback = "IlluminatePauseBuf",
        desc = "Buffer-local pause of vim-illuminate",
      },
      {
        id = "illuminate.resume_buf",
        callback = "IlluminateResumeBuf",
        desc = "Buffer-local resume of vim-illuminate",
      },
      {
        id = "illuminate.toggle_buf",
        callback = "IlluminateToggleBuf",
        desc = "Buffer-local toggle of the pause/resume for vim-illuminate",
      },
      {
        id = "illuminate.freeze",
        callback = function()
          require("illuminate").freeze_buf()
        end,
        desc = "Freeze the illumination on the buffer, this won't clear the highlights",
      },
      {
        id = "illuminate.unfreeze",
        callback = function()
          require("illuminate").unfreeze_buf()
        end,
        desc = "Unfreeze the illumination on the buffer",
      },
      {
        id = "illuminate.toggle_freeze",
        callback = function()
          require("illuminate").toggle_freeze_buf()
        end,
        desc = "Toggle the frozen state of the buffer",
      },
    },
  },
}
