---@class dotvim.extra.context_menus.groups
local M = {}

---@return dotvim.extra.ContextMenuOption
function M.build_plugin_refactor()
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = 0,
  })

  local contexts = require("refactor.actions").create_context(ft)

  ---@type dotvim.extra.ContextMenuOptions
  local ret = {}

  for _, ctx in ipairs(contexts) do
    if ctx.available() then
      ret[#ret + 1] = {
        name = ctx.name,
        cmd = function()
          vim.schedule(function()
            ctx.do_refactor()
          end)
        end,
      }
    end
  end

  ---@type dotvim.extra.ContextMenuOption
  return {
    name = "󱩽 Refactor",
    hl = "ExBlue",
    items = ret,
  }
end

---@return dotvim.extra.ContextMenuOption
function M.build_plugin_rust_lsp()
  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = 0,
  })
  ---@type dotvim.extra.ContextMenuOption
  local ret = {
    name = "󱘗 Rust LSP",
    hl = "ExBlue",
    items = {},
  }

  if ft == "rust" then
    ret.items = {
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

  return ret
end

return M
