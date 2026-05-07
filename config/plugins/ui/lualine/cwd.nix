{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_cwd = (function()
      local current_cwd

      local function refresh_current_cwd()
        local dir = vim.fn.getcwd()
        local home = os.getenv("HOME")
        if home then
          local match = string.find(dir, home, 1, true)
          if match == 1 then
            dir = "~" .. string.sub(dir, #home + 1)
          end
        end
        current_cwd = " " .. dir
      end

      vim.api.nvim_create_autocmd({
        "VimEnter",
        "DirChanged",
      }, {
        callback = function()
          refresh_current_cwd()
        end,
      })

      return {
        function()
          if not current_cwd then
            refresh_current_cwd()
          end
          return current_cwd
        end,
        color = {
          bg = _G.dotvim_resolve_fg("String"),
          fg = _G.dotvim_resolve_fg("IncSearch"),
        },
        separator = { left = "", right = "" },
      }
    end)()
  '';
}
