local M = {
  "nvim-tree/nvim-tree.lua",
  lazy = true,
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  cmd = { "NvimTreeFindFile" },
}

M.init = function()
  local RC = require("ht.core.right-click")
  RC.add_section {
    index = RC.indexes.file_explorer,
    enabled = {
      others = function(_, ft, filename)
        return ft ~= nil
          and ft ~= "NvimTree"
          and filename ~= nil
          and filename ~= ""
      end,
    },
    items = {
      {
        "Find file in FileExplorer",
        callback = function()
          vim.cmd("NvimTreeFindFile")
        end,
        keys = "f",
      },
    },
  }
end

M.config = function() -- code to run after plugin loaded
  require("nvim-tree").setup {
    auto_reload_on_write = false,
    reload_on_bufenter = false,
    disable_netrw = true,
    hijack_netrw = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    diagnostics = {
      enable = false,
      show_on_dirs = true,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = { hint = "", info = "", warning = "", error = "" },
    },
    modified = {
      enable = true,
      show_on_dirs = false,
      show_on_open_dirs = false,
    },
    update_focused_file = {
      enable = false,
      update_cwd = false,
      ignore_list = {},
    },
    system_open = { cmd = nil, args = {} },
    filters = { dotfiles = false, custom = {} },
    git = { enable = false, ignore = false, timeout = 50 },
    view = {
      width = 30,
      side = "left",
    },
    actions = { open_file = { resize_window = false } },
    renderer = {
      icons = {
        glyphs = {
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    experimental = { git = { async = true } },
  }

  local api = require("nvim-tree.api")
  require("ht.core.right-click").add_section {
    index = 1,
    enabled = {
      others = function(_, ft, _)
        print(ft)
        return ft ~= nil and ft == "NvimTree"
      end,
    },
    items = {
      {
        "Change root",
        callback = function()
          api.tree.change_root_to_node()
        end,
        keys = "<C-]>",
      },
      {
        "Run command",
        callback = function()
          api.node.run.cmd()
        end,
        keys = ".",
      },
      {
        "Show Info in pop",
        callback = function()
          api.node.show_info_pop()
        end,
        keys = "<C-k>",
      },
      {
        "Copy",
        callback = function()
          api.fs.copy.node()
        end,
        keys = "c",
      },
      {
        "Delete",
        callback = function()
          api.fs.remove()
        end,
        keys = "d",
      },
      {
        "Rename: basename",
        callback = function()
          api.fs.rename_basename()
        end,
        keys = "e",
      },
      {
        "Refresh",
        callback = function()
          api.tree.reload()
        end,
        keys = "R",
      },
      {
        "Copy name",
        callback = function()
          api.fs.copy.filename()
        end,
        keys = "y",
      },
    },
  }
end

local jump_to_nvim_tree = function()
  local n = vim.api.nvim_call_function("winnr", { "$" })
  -- find existing nvim-tree-window
  for i = 1, n do
    local win_id = vim.api.nvim_call_function("win_getid", { i })
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local tp = vim.api.nvim_buf_get_option(buf_id, "ft")

    if tp == "NvimTree" then
      vim.cmd(i .. "wincmd w")
      return
    end
  end

  require("nvim-tree.api").tree.toggle {
    find_file = false,
    focus = true,
    path = nil,
    update_root = false,
  }
end

M.keys = {
  { "<F3>", jump_to_nvim_tree, desc = "file-explorer" },
  { "<leader>ft", jump_to_nvim_tree, desc = "file-explorer" },
}

return M
