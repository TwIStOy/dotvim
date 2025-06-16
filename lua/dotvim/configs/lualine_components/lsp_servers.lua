local utils = require("dotvim.configs.lualine_components.utils")

-- Component: LSP servers and formatters
local function create_component()
  local fix_formatters_name = {
    ["clang_format"] = "clang-format",
  }

  return {
    function()
      local buf_clients = vim.lsp.get_clients {
        bufnr = 0,
      }
      local buf_ft = vim.bo.filetype
      
      if next(buf_clients) == nil then
        return "  No servers"
      end
      
      local buf_client_names = {}

      -- Add LSP clients
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end
      end

      -- Add linters
      local lint_s, lint = pcall(require, "lint")
      if lint_s then
        for ft_k, ft_v in pairs(lint.linters_by_ft) do
          if type(ft_v) == "table" then
            for _, linter in ipairs(ft_v) do
              if buf_ft == ft_k then
                table.insert(buf_client_names, linter)
              end
            end
          elseif type(ft_v) == "string" then
            if buf_ft == ft_k then
              table.insert(buf_client_names, ft_v)
            end
          end
        end
      end

      -- Add formatters
      local ok, conform = pcall(require, "conform")
      if ok then
        for _, formatter in ipairs(conform.list_formatters_for_buffer()) do
          if formatter then
            table.insert(
              buf_client_names,
              vim.F.if_nil(fix_formatters_name[formatter], formatter)
            )
          end
        end
      end

      -- Remove duplicates
      local hash = {}
      local unique_client_names = {}

      for _, v in ipairs(buf_client_names) do
        if not hash[v] then
          unique_client_names[#unique_client_names + 1] = v
          hash[v] = true
        end
      end
      
      return table.concat(unique_client_names, ", ")
    end,
    separator = { left = "", right = "" },
    color = {
      bg = utils.resolve_fg("String"),
      fg = utils.resolve_fg("IncSearch"),
      gui = "italic,bold",
    },
    padding = { left = 1 },
  }
end

return create_component
