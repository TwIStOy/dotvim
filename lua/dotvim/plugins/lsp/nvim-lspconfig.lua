local Commons = require("dotvim.commons")

---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function(_, opts)
    for lsp, config in pairs(opts.lsp_configs or {}) do
      vim.lsp.config(lsp, config)

      -- Try to replace cmd in the final merged config using Commons.which
      local final_config = vim.lsp.config[lsp]
      if
        final_config
        and final_config.cmd
        and type(final_config.cmd) == "table"
        and #final_config.cmd > 0
      then
        local resolved_cmd = Commons.which(final_config.cmd[1])
        if resolved_cmd then
          local new_cmd = vim.deepcopy(final_config.cmd)
          new_cmd[1] = resolved_cmd
          final_config.cmd = new_cmd

          -- Merge the final config to update cmd if necessary
          vim.lsp.config(lsp, final_config)
        end
      end

      vim.lsp.enable(lsp)
    end
  end,
}
