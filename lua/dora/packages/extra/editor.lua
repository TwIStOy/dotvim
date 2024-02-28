---@type dora.core.package.PackageOption
return {
  name = "dora.packages.extra.editor",
  deps = {
    "dora.packages.editor",
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
    {
      "sindrets/diffview.nvim",
      cmd = "DiffviewOpen",
      opts = {
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      },
      actions = function()
        ---@type dora.core.action
        local action = require("dora.core.action")

        ---@type dora.core.action.ActionOption[]
        local actions = {
          {
            id = "diffview.open",
            title = "Open diffview",
            callback = "DiffviewOpen",
          },
          {
            id = "diffview.close",
            title = "Close the current diffview. You can also use :tabclose.",
            callback = "DiffviewClose",
          },
          {
            id = "diffview.toggle",
            title = "Toggle the file panel.",
            callback = "DiffviewToggleFiles",
          },
          {
            id = "diffview.focus",
            title = "Bring focus to the file panel.",
            callback = "DiffviewFocusFiles",
          },
          {
            id = "diffview.refresh",
            title = "Update stats and entries in the file list of the current Diffview.",
            callback = "DiffviewRefresh",
          },
        }

        return action.make_options {
          from = "diffview.nvim",
          category = "diffview",
          actions = actions,
        }
      end,
    },
  },
}
