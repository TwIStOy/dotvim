---@type LazyPluginSpec
return {
  "stevearc/conform.nvim",
  enabled = not vim.g.vscode,
  keys = {
    {
      "<leader>fc",
      function()
        local conform = require("conform")
        conform.format {
          async = true,
          lsp_fallback = true,
        }
      end,
      desc = "format-file",
      mode = { "n", "v" },
    },
  },
  opts = {
    format = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
    },
  },
  config = function(_, opts)
    local used_formatters = {}
    for _, value in pairs(opts.formatters_by_ft) do
      if type(value) == "string" then
        used_formatters[#used_formatters + 1] = value
      elseif type(value) == "table" then
        vim.list_extend(used_formatters, value)
      end
    end

    local custom_formatters = {}
    local previous_formatters = opts.formatters or {}
    for _, formatter in ipairs(used_formatters) do
      local formatter_opts
      if previous_formatters[formatter] ~= nil then
        formatter_opts = previous_formatters[formatter]
      else
        local ok, module = pcall(require, "conform.formatters." .. formatter)
        if not ok then
          error("Formatter " .. formatter .. " not found")
        end
        formatter_opts = module
      end
      local command = formatter_opts.command
      if command == nil then
        error("Formatter " .. formatter .. " does not have a command")
      end
      local resolved_command = dv.which(command)
      if resolved_command ~= nil then
        custom_formatters[formatter] =
          vim.tbl_extend("force", formatter_opts, {
            command = resolved_command,
          })
      end
    end

    opts.formatters =
      vim.tbl_extend("force", previous_formatters, custom_formatters)
    require("conform").setup(opts)
  end,
}
