---@type dotvim.core.plugin.PluginOption
return {
  "ibhagwan/fzf-lua",
  url = "https://gitlab.com/ibhagwan/fzf-lua.git",
  dependencies = {
    "nvim-web-devicons",
  },
  lazy = true,
  opts = {},
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

    require("fzf-lua").setup(opts)
  end,
}
