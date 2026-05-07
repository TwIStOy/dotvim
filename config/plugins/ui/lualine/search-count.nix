{
  plugins.lualine.luaConfig.pre = ''
    _G.dotvim_lualine_search_count = {
      function()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local ok, result = pcall(vim.fn.searchcount, {
          maxcount = 999,
          timeout = 500,
        })
        if not ok or next(result) == nil then
          return ""
        end
        local denominator = math.min(result.total, result.maxcount)
        return string.format("%d/%d", result.current, denominator)
      end,
      color = {
        bg = _G.dotvim_resolve_fg("IncSearch"),
        fg = _G.dotvim_resolve_bg("Normal"),
        gui = "bold",
      },
      separator = { left = "", right = "" },
    }
  '';
}
