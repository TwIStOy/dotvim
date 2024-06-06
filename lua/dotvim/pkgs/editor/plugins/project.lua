return {
  "TwIStOy/project.nvim",
  event = {
    "BufReadPost",
    "BufNewFile",
  },
  opts = function(_, opts)
    ---@type dotvim.utils
    local Utils = require("dotvim.utils")
    opts.manual_mode = true
    opts.patterns = Utils.tbl.merge_array(opts.patterns, {
      "BLADE_ROOT",
      "blast.json",
      ".git",
      "_darcs",
      ".hg",
      ".bzr",
      ".svn",
      "Makefile",
      "package.json",
      "HomePage.md", -- for my personal obsidian notes
    })
    opts.exclude_dirs = Utils.tbl.merge_array(opts.exclude_dirs, {
      "~/.cargo/*",
    })
    opts.silent_chdir = false
    opts.show_hidden = true
  end,
  config = function(_, opts)
    opts = opts or {}
    require("project_nvim").setup(opts)

    local resolve_project_root = function()
      local ok, value =
        pcall(vim.api.nvim_buf_get_var, 0, "_dotvim_project_cwd")
      if ok and value ~= nil then
        return
      end
      local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
      if ft == "help" then
        return
      end
      local root, _ = require("project_nvim.project").get_project_root()
      if root == nil then
        return
      end
      vim.api.nvim_buf_set_var(0, "_dotvim_project_cwd", root)
      if string.find(string.lower(root), "agora") then
        vim.api.nvim_buf_set_var(0, "_dotvim_project_no_ignore", true)
      end
    end

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "*",
      callback = function()
        resolve_project_root()
      end,
    })
  end,
}
