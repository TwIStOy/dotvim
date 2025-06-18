local utils = require("dotvim.configs.lualine_components.utils")

-- Global cache for enabled servers per buffer
local buffer_cache = {}
local cache_initialized = false

-- Initialize event listeners once
local function init_cache_events()
  if cache_initialized then
    return
  end
  cache_initialized = true

  -- Create augroup first
  local augroup = vim.api.nvim_create_augroup("lualine_lsp_servers_cache", { clear = true })

  -- Clear cache when LSP clients attach/detach, filetype changes, or buffer is deleted
  vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "FileType", "BufDelete" }, {
    group = augroup,
    callback = function(event)
      local bufnr = event.buf
      buffer_cache[bufnr] = nil
    end,
  })
end

-- Component: LSP servers and formatters
local function create_component()
  local fix_formatters_name = {
    ["clang_format"] = "clang-format",
  }

  init_cache_events()

  local function get_enabled_servers()
    local current_buffer = vim.api.nvim_get_current_buf()

    -- Check if we have a valid cache entry for this buffer
    local cached_entry = buffer_cache[current_buffer]
    if cached_entry then
      return cached_entry.servers
    end

    local current_filetype = vim.bo.filetype
    local buf_clients = vim.lsp.get_clients { bufnr = current_buffer }

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
            if current_filetype == ft_k then
              table.insert(buf_client_names, linter)
            end
          end
        elseif type(ft_v) == "string" then
          if current_filetype == ft_k then
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

    local result = table.concat(unique_client_names, ",")

    if #unique_client_names == 0 then
      local result = "No servers"
      buffer_cache[current_buffer] = {
        servers = result,
      }
      return result
    end
    
    -- Update cache for this buffer
    buffer_cache[current_buffer] = {
      servers = result,
    }
    
    return result
  end

  return {
    function()
      return get_enabled_servers()
    end,
    separator = { left = "", right = "" },
    color = {
      bg = utils.resolve_fg("String"),
      fg = utils.resolve_fg("IncSearch"),
      gui = "italic,bold",
    },
    padding = { left = 0 },
  }
end

return create_component
