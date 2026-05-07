{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_lsp_progress = (function()
      local current_message = ""

      local function update_message()
        local ok, lsp_progress = pcall(require, "lsp-progress")
        if not ok then
          current_message = ""
          return
        end
        current_message = lsp_progress.progress({
          max_size = 80,
          format = function(messages)
            if #messages > 0 then
              return table.concat(messages, " ")
            end
            return ""
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LspProgressStatusUpdated",
        callback = update_message,
      })

      return {
        function()
          return current_message or ""
        end,
        separator = { left = "", right = "" },
        color = {
          bg = _G.dotvim_resolve_bg("CursorLine"),
          fg = _G.dotvim_resolve_fg("Comment"),
          gui = "bold",
        },
      }
    end)()
  '';
}
