---@type LazyPluginSpec[]
return {
  {
    "ibhagwan/fzf-lua",
    enabled = false, -- Replaced by snacks.picker
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua" },
    keys = {
      { "<leader>e", "<cmd>FzfLua files<cr>", desc = "find-files" },
      { "g/", "<cmd>FzfLua live_grep<cr>", desc = "live-grep" },
    },
    opts = {
      "telescope",
      winopts = {
        border = "rounded",
        preview = {
          default = "bat",
          wrap = "nowrap",
          hidden = "nohidden",
        },
      },
      keymap = {
        builtin = {
          false,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          false,
        },
      },
      previewers = {
        bat = {
          theme = "Catppuccin Mocha",
        },
        git_diff = {
          pager = "diff-so-fancy",
        },
      },
    },
    config = function(_, opts)
      local commons = require("dotvim.commons")

      -- Fix binary paths using the commons which function
      local bins = {
        { "fzf", { "fzf_bin" } },
        { "cat", { "previewers", "cat", "cmd" } },
        { "bat", { "previewers", "bat", "cmd" } },
        { "head", { "previewers", "head", "cmd" } },
      }

      for _, bin in ipairs(bins) do
        local executable = commons.which(bin[1])
        if executable then
          local path = bin[2]
          if path[1] == "fzf_bin" then
            opts.fzf_bin = executable
          else
            local previewer = vim.tbl_get(opts, "previewers", path[2])
            if previewer then
              previewer.cmd = executable
            end
          end
        end
      end

      local fzf_lua = require("fzf-lua")
      fzf_lua.setup(opts)
    end,
  },
}
