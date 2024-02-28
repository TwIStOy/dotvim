---@class dora.config.vim
local M = {}

---@class dora.config.vim.SetupOption
---@field relative_number_blacklist? string[]
---@field cursorline_blacklist? string[]
---@field quick_close_filetypes? string[]

---@type dora.config.vim.SetupOption
local SetupOption = {
  ---@type string[]
  relative_number_blacklist = {
    "startify",
    "NvimTree",
    "packer",
    "alpha",
    "nuipopup",
    "toggleterm",
    "noice",
    "crates.nvim",
    "lazy",
    "Trouble",
    "rightclickpopup",
    "TelescopePrompt",
    "Glance",
    "DressingInput",
    "lspinfo",
    "nofile",
    "mason",
    "Outline",
    "aerial",
    "flutterToolsOutline",
    "neo-tree",
    "neo-tree-popup",
    "",
  },
  ---@type string[]
  cursorline_blacklist = {
    "alpha",
    "noice",
    "mason",
  },
  ---@type string[]
  quick_close_filetypes = {
    "qf",
    "help",
    "man",
    "notify",
    "nofile",
    "lspinfo",
    "terminal",
    "prompt",
    "toggleterm",
    "copilot",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
    "aerial",
    "Outline",
    "ClangdAST",
  },
  ---@type string[]
  uncountable_filetypes = {
    "quickfix",
    "defx",
    "CHADTree",
    "NvimTree",
    "noice",
    "fidget",
    "scrollview",
    "notify",
    "Trouble",
    "sagacodeaction",
    "rightclickpopup",
    "DiffviewFiles",
    "neo-tree",
    "neo-tree-popup",
    "NvimSeparator",
  },
}
M.config = SetupOption

---@param opts dora.config.vim.SetupOption
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts)
end

function M.is_uncountable(win_id)
  local buf_id = vim.api.nvim_win_get_buf(win_id)
  local ft = vim.api.nvim_get_option_value("ft", {
    buf = buf_id,
  })
  local bt = vim.api.nvim_get_option_value("buftype", {
    buf = buf_id,
  })

  local lookup_table =
    vim.tbl_add_reverse_lookup(vim.deepcopy(M.config.uncountable_filetypes))

  return (lookup_table[ft] ~= nil and lookup_table[ft])
    or (lookup_table[bt] ~= nil and lookup_table[bt])
end

function M.check_last_window()
  local n = vim.api.nvim_call_function("winnr", { "$" })
  local total = n
  for i = 1, n do
    local win_id = vim.api.nvim_call_function("win_getid", { i })
    if M.is_uncountable(win_id) then
      total = total - 1
    end
  end

  if total == 0 then
    if vim.api.nvim_call_function("tabpagenr", { "$" }) == 1 then
      vim.api.nvim_command("quitall!")
    else
      vim.api.nvim_command("tabclose")
    end
  end
end

return M
