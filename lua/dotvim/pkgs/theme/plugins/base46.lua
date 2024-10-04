---@type dotvim.core.plugin.PluginOption
return {
  "nvchad/base46",
  lazy = true,
  enabled = false,
  build = function()
    require("base46").load_all_highlights()
  end,
  init = function()
    -- load all highlighs at once
    for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
      dofile(vim.g.base46_cache .. v)
    end
  end,
}
