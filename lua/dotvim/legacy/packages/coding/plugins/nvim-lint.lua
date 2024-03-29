---@type dora.core.plugin.PluginOption
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    linters_by_ft = {},
  },
  config = function(_, opts)
    require("lint").linters_by_ft = opts.linters_by_ft

    local used_linters = {}
    for _, linter in pairs(opts.linters_by_ft) do
      if type(linter) == "string" then
        used_linters[#used_linters + 1] = linter
      else
        for _, l in pairs(linter) do
          used_linters[#used_linters + 1] = l
        end
      end
    end

    ---@type dora.utils
    local utils = require("dora.utils")
    for _, name in pairs(used_linters) do
      local linter = require("lint").linters[name]
      if linter == nil then
        error("Linter " .. linter .. " not found")
      end
      linter.cmd = utils.which_binary(linter.cmd)
    end

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
