{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_file = (function()
      local current_file = " " .. "Empty"

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "DirChanged",
      }, {
        callback = function()
          local file_icon = "" .. " "
          local currentFile = vim.fn.expand("%")
          local filename
          if currentFile == "" then
            filename = "Empty"
          else
            filename = vim.fn.fnamemodify(currentFile, ":.")
            local deviconsPresent, devicons = pcall(require, "nvim-web-devicons")
            if deviconsPresent then
              local ftIcon = devicons.get_icon(filename)
              if ftIcon ~= nil then
                file_icon = ftIcon .. " "
              end
              if vim.fn.expand("%:e") == "md" then
                file_icon = file_icon .. " "
              end
            end
          end
          current_file = file_icon .. filename
        end,
      })

      return {
        function()
          return current_file
        end,
        color = {
          bg = _G.dotvim_resolve_bg("CursorLine"),
          fg = _G.dotvim_resolve_fg("Normal"),
        },
        separator = { left = "", right = "" },
        padding = { left = 1 },
      }
    end)()
  '';
}
