# Project-local exrc loader (minimal glue for nixvim)
#
# We deliberately do NOT re-implement the search + trust logic.
# Instead we reuse Neovim's own official module:
#     require('vim._core.exrc')
#
# That module (only ~20 lines) already does:
#   - vim.fs.find({'.nvim.lua', '.nvimrc', '.exrc'}, { upward = true })
#   - vim.secure.read (the real trust prompt + hash database)
#   - loadstring / nvim_exec2
#   - respects `set noexrc` inside the loaded file
#
# The only things we need to provide on top:
#   1. Headless guard (so nixvim's check derivation doesn't blow up)
#   2. Trigger it at the right moments (VimEnter + global DirChanged)
#   3. A :ProjectLocalLoad command for manual re-run
#
# This is the smallest possible pure-Nix workaround.
{
  extraConfigLua = ''
    -- Reuse the real exrc implementation from Neovim runtime.
    local function load()
      -- Never run in headless (nixvim check, --headless, CI, etc.).
      -- vim.secure.read calls confirm() which requires a UI.
      if #vim.api.nvim_list_uis() == 0 then
        return
      end

      -- The official module already checks vim.o.exrc internally.
      require('vim._core.exrc')
    end

    -- Expose for manual use
    _G.load_project_local = load

    -- :ProjectLocalLoad — just call the real thing again
    pcall(vim.api.nvim_create_user_command, 'ProjectLocalLoad', load, {
      desc = 'Reload project-local .nvim.lua / .exrc using Neovim built-in logic',
    })

    -- Wire the triggers (protected)
    local function setup()
      local group = vim.api.nvim_create_augroup('DotvimProjectLocal', { clear = true })

      vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
        group = group,
        callback = function(ev)
          if ev.event == 'DirChanged' and ev.match ~= 'global' then
            return
          end
          -- Schedule so we run after other DirChanged handlers and after UI is ready
          vim.schedule(load)
        end,
        desc = 'Load project-local exrc via vim._core.exrc (nixvim timing workaround)',
      })
    end

    pcall(setup)
  '';
}
