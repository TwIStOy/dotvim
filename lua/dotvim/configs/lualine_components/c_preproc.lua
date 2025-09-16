local utils = require("dotvim.configs.lualine_components.utils")

-- Shows the active chain of C preprocessor conditionals (#if/#elif/#ifdef/#ifndef)
-- gathered by dotvim.configs.cpp.find_preproc_ifdef_from_cursor
-- Format example: #if FOO && BAR > 1 | #ifdef DEBUG | #ifndef TEST
-- For macro-only directives we show: #ifdef MACRO or #ifndef MACRO
-- For #if/#elif we show: #if <expr> / #elif <expr>
-- When no chain, returns empty string so lualine hides it.
return function()
  return {
    function()
      local ok, cpp = pcall(require, "dotvim.configs.cpp")
      if not ok or not cpp.find_preproc_ifdef_from_cursor then
        return ""
      end
      local chain = cpp.find_preproc_ifdef_from_cursor()
      if not chain or #chain == 0 then
        return ""
      end
      local parts = {}
      for _, item in ipairs(chain) do
        if item.directive == "ifdef" or item.directive == "ifndef" then
          table.insert(
            parts,
            string.format("#%s %s", item.directive, item.macro)
          )
        elseif item.directive == "if" or item.directive == "elif" then
          table.insert(
            parts,
            string.format("#%s %s", item.directive, item.expr)
          )
        end
      end
      local ret = table.concat(parts, " | ")
      return ret
    end,
    color = {
      bg = utils.resolve_fg("Macro"),
      fg = utils.resolve_fg("IncSearch"),
      gui = "bold",
    },
    separator = { left = "", right = "" },
  }
end
