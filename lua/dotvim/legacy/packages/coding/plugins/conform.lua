---@type dora.core.plugin.PluginOption
return {
  "stevearc/conform.nvim",
  gui = "all",
  opts = {
    format = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
    },
    formatters = {},
    formatters_by_ft = {},
  },
  cmd = { "Conform" },
  event = { "BufReadPost" },
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
  config = function(_, opts)
    local used_formatters = {}
    for _, value in pairs(opts.formatters_by_ft) do
      if type(value) == "string" then
        used_formatters[#used_formatters + 1] = value
      else
        for _, val in ipairs(value) do
          if type(val) == "string" then
            used_formatters[#used_formatters + 1] = val
          else
            vim.list_extend(used_formatters, val)
          end
        end
      end
    end

    ---@type dora.utils
    local utils = require("dora.utils")

    local custom_formatters = {}
    for _, formatter in ipairs(used_formatters) do
      local formatter_opts
      if opts.formatters[formatter] ~= nil then
        formatter_opts = opts.formatters[formatter]
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
      local resolved_command = utils.which_binary(command)
      if resolved_command ~= command then
        custom_formatters[formatter] = vim.tbl_extend("force", formatter_opts, {
          command = resolved_command,
        })
      end

      opts.formatters =
        vim.tbl_extend("force", opts.formatters, custom_formatters)

      require("conform").setup(opts)
    end
  end,
}
