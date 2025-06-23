---@module "dotvim.plugins.fzf"

local Commons = require("dotvim.commons")

---@type LazyPluginSpec[]
return {
  {
    "ibhagwan/fzf-lua",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua" },
    keys = {
      { "<leader>e", "<cmd>FzfLua files<cr>", desc = "find-files" },
      { "g/", "<cmd>FzfLua live_grep<cr>", desc = "live-grep" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "document-symbols" },
      { "<leader>sw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "workspace-symbols" },
    },
    opts = function()
      local actions = require("fzf-lua.actions")
      
      return {
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
            ["<C-d>"]    = "preview-page-down",
            ["<C-u>"]      = "preview-page-up",
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
      }
    end,
    config = function(_, opts)
      if type(opts) == "function" then
        opts = opts()
      end
      
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
          elseif path[1] == "previewers" and path[2] and path[3] == "cmd" then
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
