local function setup_keymaps()
  NMAP("gf", function()
    if require("obsidian").util.cursor_on_markdown_link() then
      vim.api.nvim_command("ObsidianFollowLink")
    end
  end, "obsidian-follow-link", { buffer = true })
end

local M = {
  "TwIStOy/obsidian.nvim",
  lazy = {
    lazy = true,
    event = {
      "BufReadPre *.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
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
    notes_subdir = "Database",
    log_level = vim.log.levels.WARN,
    daily_notes = {
      folder = "Journal",
    },
    completion = {
      nvim_cmp = true,
      new_notes_location = "notes_subdir",
    },
    use_advanced_uri = true,
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(97, 122))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
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
