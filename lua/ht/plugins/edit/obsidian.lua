local function setup_keymaps()
  NMAP("gf", function()
    if require("obsidian").util.cursor_on_markdown_link() then
      vim.api.nvim_command("ObsidianFollowLink")
    end
  end, "obsidian-follow-link", { buffer = true })
end

local M = {
  "epwalsh/obsidian.nvim",
  lazy = {
    lazy = true,
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
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianSearch",
      "ObsidianQuickSwitch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianTemplate",
    },
    cond = function()
      return require("ht.core.globals").has_obsidian_vault
    end,
  },
  functions = {
    {
      values = {
        FuncSpec("Create a new daily note", "ObsidianToday"),
        FuncSpec(
          "Open (eventually creating) the daily note for the previous working day",
          "ObsidianYesterday"
        ),
        FuncSpec("Create a new note", ExecFunc("ObsidianNew")),
        FuncSpec(
          "Search for notes in your vault using ripgrep with telescope.nvim",
          ExecFunc("ObsidianSearch")
        ),
      },
    },
    {
      filter = {
        ft = "markdown",
      },
      values = {
        FuncSpec(
          "Getting a location list of references to the current buffer",
          "ObsidianBacklinks"
        ),
        FuncSpec("Open a note in the Obsidian app", ExecFunc("ObsidianOpen")),
        FuncSpec(
          "Quickly switch to another notes in your vault",
          "ObsidianQuickSwitch"
        ),
        FuncSpec(
          "Link an in-line visual selection of text to a note",
          ExecFunc("ObsidianLink")
        ),
        FuncSpec(
          "Create a new note and link it to an in-line visual selection of text",
          ExecFunc("ObsidianLinkNew")
        ),
        FuncSpec(
          "Insert a template from the templates folder",
          "ObsidianTemplate"
        ),
      },
    },
  },
}

M.lazy.config = function()
  local obsidian = require("obsidian").setup {
    dir = require("ht.core.globals").obsidian_vault,
    notes_subdir = "2-Outputs/0-Zettel",
    log_level = vim.log.levels.WARN,
    daily_notes = {
      folder = "2-Outputs/1-Journal",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = "daily-note.md",
    },
    completion = {
      nvim_cmp = true,
      new_notes_location = "notes_subdir",
    },
    templates = {
      subdir = "0-Assets/Templates.nvim",
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
    note_id_func = function(_)
      return ("%0x-%0x-%x"):format(
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
      if
        note.metadata ~= nil
        and require("obsidian").util.table_length(note.metadata) > 0
      then
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
  }

  local au_group =
    vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufWinEnter" }, {
    group = au_group,
    pattern = tostring(obsidian.dir / "**.md"),
    callback = function()
      setup_keymaps()
    end,
  })
end

return Use(M)
