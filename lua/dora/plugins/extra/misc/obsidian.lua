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
      opts = opts or {}
      opts = vim.tbl_extend("force", opts, {
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
      })
    end,
    config = function(_, opts)
      local obsidian = require("obsidian")
      obsidian.setup(opts)
      local au_group =
        vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })
      vim.api.nvim_create_autocmd(
        { "BufNewFile", "BufReadPost", "BufWinEnter" },
        {
          group = au_group,
          pattern = tostring(obsidian.dir / "**.md"),
          callback = function()
            vim.wo.conceallevel = 2
            vim.keymap.set("n", "gf", function()
              if require("obsidian").util.cursor_on_markdown_link() then
                vim.api.nvim_command("ObsidianFollowLink")
              end
            end, {
              buffer = true,
              desc = "obsidian-follow-link",
            })
          end,
        }
      )
    end,
    actions = function()
      local global_actions = lib.plguin.action.make_options {
        from = "obsidian.nvim",
        category = "obsidian",
        ---@type dora.lib.ActionOptions[]
        actions = {
          {
            id = "obsidian.today",
            description = "Create/Open today's note",
            callback = "ObsidianToday",
          },
          {
            id = "obsidian.yesterday",
            description = "Create/Open yesterday's note",
            callback = "ObsidianYesterday",
          },
          {
            id = "obsidian.new-note",
            description = "Create a new note",
            callback = "ObsidianNew",
          },
          {
            id = "obsidian.quick-switch",
            description = "Quick switch to a note",
            callback = "ObsidianQuickSwitch",
          },
        },
      }
      local vault_actions = lib.plugin.action.make_options {
        from = "obsidian.nvim",
        category = "obsidian",
        ---@param buf dora.lib.vim.Buffer
        condition = function(buf)
          local obsidian = require("obsidian")
          return buf.filetype == "markdown"
            and buf.full_file_name:find(obsidian.dir, 1, true) ~= nil
        end,
        ---@type dora.lib.ActionOptions[]
        actions = {
          {
            id = "obsidian.backlinks",
            description = "Show backlinks",
            callback = "ObsidianBacklinks",
          },
          {
            id = "obsidian.open-note",
            description = "Open current note in the Obsidian app",
            callback = "ObsidianOpen",
          },
          {
            id = "obsidian.insert-template",
            description = "Insert a template from the templates folder",
            callback = "ObsidianTemplate",
          },
        },
      }
      return vim.list_extend(global_actions, vault_actions)
    end,
  },
}
