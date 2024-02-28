---@type dora.core.package.PackageOption
return {
  name = "extra.editor",
  deps = {
    "editor",
  },
  plugins = {
    {
      "folke/flash.nvim",
      event = "BufReadPost",
      dependencies = {
        {
          "telescope.nvim",
          opts = function(_, opts)
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
                    require("telescope.actions.state").get_current_picker(
                      prompt_bufnr
                    )
                  picker:set_selection(match.pos[1] - 1)
                end,
              }
            end
            opts.defaults.mappings.i["<C-s>"] = flash
            opts.defaults.mappings.n["s"] = flash
          end,
        },
      },
    },
  },
}
