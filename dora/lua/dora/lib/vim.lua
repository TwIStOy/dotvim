---@class dora.lib.vim
local M = {}

---@class dora.lib.vim.BufferWrapper Buffer relative properties
---@field bufnr number
---@field filetype string
---@field full_file_name string
---@field lsp_servers lsp.Client[]
---@field ts_highlighter vim.treesitter.highlighter[]
local Buffer = {}

---@return string
function Buffer:as_cache_key()
  local arr = {
    self.filetype,
    self.full_file_name,
    #self.lsp_servers,
    #self.ts_highlighter,
  }
  for _, v in ipairs(self.lsp_servers) do
    arr[#arr + 1] = v.name
  end
  return vim.json.encode(arr)
end

---Returns the number of language servers attached to the buffer except
---`null-ls`, `copilot` and `none-ls`.
---@return number
function Buffer:lang_server_count()
  local count = 0
  for _, v in ipairs(self.lsp_servers) do
    if v.name ~= "null-ls" and v.name ~= "copilot" and v.name ~= "none-ls" then
      count = count + 1
    end
  end
  return count
end

---@param bufnr number
---@return dora.lib.vim.BufferWrapper
function M.wrap_buffer(bufnr)
  return setmetatable({
    bufnr = bufnr,
    filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
    full_file_name = vim.api.nvim_buf_get_name(bufnr),
    lsp_servers = vim.lsp.get_clients {
      bufnr = bufnr,
    },
    ts_highlighter = { vim.treesitter.highlighter.active[bufnr] },
  }, {
    __index = Buffer,
  })
end

---@return string?
function M.current_gui()
  if vim.g.vscode then
    return "vscode"
  elseif vim.g.neovide then
    return "neovide"
  else
    return nil
  end
end

---@param cmd string
---@return fun():any
function M.input_then_exec(cmd)
  return function()
    vim.ui.input({
      prompt = "Arguments, " .. cmd,
    }, function(input)
      if input then
        if input.length > 0 then
          vim.api.nvim_command(cmd .. input)
        else
          vim.api.nvim_command(cmd)
        end
      end
    end)
  end
end

---@param callback fun(client?: lsp.Client, buffer: number)
function M.on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      ---@type lsp.Client?
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, buffer)
    end,
  })
end

return M
