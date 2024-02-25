local lib = require("dora.lib")
local config = require("dora.config")

---@return string?
local function resolve_obsidian_vault()
  ---@type string[]
  local paths = lib.tbl.optional_field(config.config, "paths", "obsidian_vault")
    or {}
  for _, path in ipairs(paths) do
    local p = vim.fn.resolve(vim.fn.expand(path))
    if vim.fn.isdirectory(p) == 1 then
      return p
    end
  end
  return nil
end

---@type dora.lib.PluginOptions[]
return {
  {
    "TwIStOy/obsidian.nvim",
    event = {
      ("BufReadPre %s/*.md"):format(require("ht.core.globals").obsidian_vault),
      ("BufNewFile %s/*.md"):format(require("ht.core.globals").obsidian_vault),
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "godlygeek/tabular",
      "dhruvasagar/vim-table-mode",
    },
    cmd = {
      "ObsidianBacklinks",
      "ObsidianExtractNote",
      "ObsidianFollowLink",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianNew",
      "ObsidianOpen",
      "ObsidianPasteImg",
      "ObsidianQuickSwitch",
      "ObsidianRename",
      "ObsidianSearch",
      "ObsidianTags",
      "ObsidianTemplate",
      "ObsidianToday",
      "ObsidianTomorrow",
      "ObsidianWorkspace",
      "ObsidianYesterday",
    },
    cond = lib.cache.call_once(resolve_obsidian_vault),
    opts = function(_, opts)
      local opts = opts or {}
    end,
    actions = lib.plguin.action.make_options {
      from = "obsidian.nvim",
    },
  },
}
