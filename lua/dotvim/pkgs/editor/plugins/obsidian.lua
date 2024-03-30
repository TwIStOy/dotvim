local Shared = require("dotvim.pkgs.editor.shared")

local default_vault_path = {
  "~/Documents/Main",
  "~/Projects/obsidian-data/Main",
}

local function resolve_obsidian_vault()
  for _, path in ipairs(default_vault_path) do
    local p = vim.fn.resolve(vim.fn.expand(path))
    if vim.fn.isdirectory(p) == 1 then
      return p
    end
  end
  return vim.fn.resolve(vim.fn.expand(default_vault_path[1]))
end

---@type dotvim.core.plugin.PluginOption
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  event = function()
    return {
      ("BufReadPre %s/*.md"):format(Shared.vault_dir()),
      ("BufNewFile %s/*.md"):format(Shared.vault_dir()),
    }
  end,
  dependencies = {
    "plenary.nvim",
    "telescope.nvim",
    "nvim-treesitter",
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
  opts = {
    dir = resolve_obsidian_vault(),
    notes_subdir = "3-Resources/0-Zettel",
    log_level = vim.log.levels.WARN,
    daily_notes = {
      folder = "3-Resources/0-Dairy",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "Templates.nvim/daily-note.md",
    },
    new_notes_location = "notes_subdir",
    completion = {
      nvim_cmp = true,
    },
    templates = {
      subdir = "0-Assets",
      substitutions = {
        daily_title = function()
          return os.date("%B %-d, %Y")
        end,
        daily_date = function()
          return os.date("%Y-%m-%d")
        end,
      },
    },
    use_advanced_uri = true,
    mappings = {},
    note_id_func = function(_)
      return ("%0x-%04x-%4x"):format(
        os.time(),
        math.random(0, 0xffff),
        math.random(0, 0xffff)
      )
    end,
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags,
        lastModifiedTime = os.date("%Y-%m-%d"),
      }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          if out[k] == nil then
            out[k] = v
          end
        end
      end
      if out["createdTime"] == nil then
        out["createdTime"] = out["lastModifiedTime"]
      end
      return out
    end,
    yaml_parser = "yq",
  },
}
