local function find_files()
  local cwd = vim.b._dotvim_project_cwd
  require("fzf-lua").files {
    cwd = cwd,
  }
end

local function live_grep()
  local cwd = vim.b._dotvim_project_cwd
  require("fzf-lua").live_grep {
    cwd = cwd,
  }
end

---@type dotvim.core.plugin.PluginOption
return {
  "ibhagwan/fzf-lua",
  url = "https://gitlab.com/ibhagwan/fzf-lua.git",
  dependencies = {
    "nvim-web-devicons",
  },
  lazy = true,
  opts = {
    winopts = {
      preview = {
        default = "bat",
      },
    },
  },
  cmd = { "FzfLua" },
  config = function(_, opts)
    ---@type dotvim.utils
    local Utils = require("dotvim.utils")
    opts = opts or {}

    local bins = {
      { "fzf", { "fzf_bin" } },
      { "cat", { "previewers", "cat", "cmd" } },
      { "bat", { "previewers", "bat", "cmd" } },
      { "head", { "previewers", "head", "cmd" } },
    }

    for _, bin in ipairs(bins) do
      Utils.fix_opts_cmd(opts, bin[1], unpack(bin[2]))
    end

    opts[1] = { "telescope" }

    require("fzf-lua").setup(opts)
  end,
  actions = function()
    local ret = {}

    ret[#ret + 1] = {
      id = "fzf-lua.find-files",
      callback = find_files,
      title = "Edit project files",
      keys = { "<leader>e", desc = "edit-project-files" },
    }
    ret[#ret + 1] = {
      id = "fzf-lua.live-grep",
      callback = live_grep,
      title = "Search for a string in current working directory",
      keys = {
        { "<leader>lg", desc = "live-grep" },
        { "g/", desc = "live-grep" },
      },
    }

    return ret
  end,
}
