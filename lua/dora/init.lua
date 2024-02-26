local M = {}

local function make_sure_lazy_installed()
  ---@type dora.config.SetupOptions
  local config = require("dora.config").config

  if not vim.uv.fs_stat(config.paths.lazy) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      config.paths.lazy,
    }
  end
  vim.opt.rtp:prepend(config.paths.lazy)
end

---@param opts? dora.config.SetupOptions
function M.setup(opts)
  require("dora.config").setup(opts)
end

return M
