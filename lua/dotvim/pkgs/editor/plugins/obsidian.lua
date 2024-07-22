local Shared = require("dotvim.pkgs.editor.shared")

local default_vault_path = {
  "~/Projects/digital-garden/Digital Garden",
  "~/Projects/obsidian-data/Main",
  "~/Documents/Main",
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
    "ObsidianNewFromTemplate",
  },
  opts = {
    dir = resolve_obsidian_vault(),
    notes_subdir = "2-Zettel",
    log_level = vim.log.levels.WARN,
    daily_notes = {
      folder = "3-Journal",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "Templates.nvim/journal-template.md",
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
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-:]", ""):lower()
      else
        -- If title is nil, just add 6 random uppercase letters to the suffix.
        for _ = 1, 6 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return ("%s - %s"):format(os.date("%Y%m%d%H%M"), suffix)
    end,
    note_frontmatter_func = function(note)
      local out = {
        aliases = note.aliases,
        tags = note.tags,
      }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          if out[k] == nil then
            out[k] = v
          end
        end
      end
      return out
    end,
    callbacks = {
      enter_note = function(client, note)
        local util = require("obsidian.util")
        local vault_name = client:vault_name()
        local path =
          tostring(client:vault_relative_path(note.path, { strict = true }))
        local encoded_vault = util.urlencode(vault_name)
        local encoded_path = util.urlencode(path)
        local line = vim.api.nvim_win_get_cursor(0)[1] or 1
        local uri = ("obsidian://advanced-uri?vault=%s&filepath=%s&line=%i&viewmode=preview"):format(
          encoded_vault,
          encoded_path,
          line
        )
        uri = vim.fn.shellescape(uri)
        local cmd = "open"
        local args = { "-a", "/Applications/Obsidian.app", "--background", uri }
        local cmd_with_args = cmd .. " " .. table.concat(args, " ")
        vim.fn.jobstart(cmd_with_args, {
          on_exit = function(_, exit_code)
            if exit_code ~= 0 then
              vim.notify(
                ("open command failed with exit code '%s': %s"):format(
                  exit_code,
                  cmd_with_args
                ),
                vim.log.levels.ERROR
              )
            end
          end,
        })
      end,
    },
    yaml_parser = "yq",
  },
}
