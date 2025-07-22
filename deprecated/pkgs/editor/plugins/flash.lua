local function flash(prompt_bufnr)
  require("flash").jump {
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
            ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker =
        require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  }
end

---@type dotvim.core.plugin.PluginOption
return {
  "folke/flash.nvim",
  event = "BufReadPost",
  opts = {
    modes = { search = { enabled = false } },
  },
  keys = {
    {
      "s",
      function()
        require("flash").jump()
      end,
      desc = "flash search",
    },
  },
  dependencies = {
    {
      "telescope.nvim",
      opts = {
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = flash,
            },
            n = {
              s = flash,
            },
          },
        },
      },
    },
  },
}
