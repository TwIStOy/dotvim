---@class dotvim.extra.context_menus.langs.rust
local M = {}

---@param buf number
---@return dotvim.extra.ContextMenuOptions
function M.build_context_menu_options(buf)
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = buf,
  })

  if ft == "rust" then
    return {
      {
        name = "Expand macro",
        rtxt = "e",
        cmd = function()
          vim.api.nvim_command("RustLsp expandMacro")
        end,
      },
      {
        name = "Rebuild proc macro",
        rtxt = "r",
        cmd = function()
          vim.api.nvim_command("RustLsp rebuildProcMacro")
        end,
      },
      {
        name = "Open cargo.toml",
        rtxt = "c",
        cmd = function()
          vim.api.nvim_command("RustLsp openCargo")
        end,
      },
      {
        name = "Open parent module",
        rtxt = "p",
        cmd = function()
          vim.api.nvim_command("RustLsp parentModule")
        end,
      },
    }
  end

  return {}
end

return M
