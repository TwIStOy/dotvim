local M = {}

M.requires = function() -- return required packages
end

M.setup = function() -- code to run before plugin loaded
end

M.config = function() -- code to run after plugin loaded
  require'gitsigns'.setup {
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = { virt_text = true, delay = 200 },
  }
  require'gitsigns.highlight'.setup_highlights()
end

M.mappings = function() -- code for mappings
  return {
    default = { -- pass to vim.api.nvim_set_keymap
    },
    wk = { -- send to which-key
      mappings = {
        ["*"] = {
          v = {
            name = 'vcs',
            s = {
              function()
                require'gitsigns'.stage_hunk()
              end,
              'stage-hunk',
            },
            u = {
              function()
                require'gitsigns'.undo_stage_hunk()
              end,
              'undo-stage-hunk',
            },
            m = {
              function()
                require'gitsigns'.blame_line { full = true }
              end,
              'show-commit',
            },
          },
        },
      },
      opt = { prefix = '<leader>' },
    },
  }
end

return M
-- vim: et sw=2 ts=2 fdm=marker

