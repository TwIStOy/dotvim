---@class dotvim.extra.context_menus.langs.cpp
local M = {}

---@type dotvim.extra.context_menus.utils
local Utils = require("dotvim.extra.context_menus.utils")

---@param buf number
---@return dotvim.extra.ContextMenuOptions
function M.build_context_menu_options(buf)
  ---@type dotvim.extra.ContextMenuOptions
  local ret = {}

  local lsp_clients = vim.lsp.get_clients {
    bufnr = buf,
    name = "clangd",
  }
  if #lsp_clients > 0 then
    -- clangd attached
    Utils.append_group(ret, {
      {
        name = "Type hierarchy",
        rtxt = "t",
        cmd = function()
          vim.cmd("ClangdTypeHierarchy")
        end,
      },
      {
        name = "Switch source/header",
        rtxt = "s",
        cmd = function()
          vim.cmd("ClangdSwitchSourceHeader")
        end,
      },
    })
  end

  local ft = vim.api.nvim_get_option_value("filetype", {
    buf = buf,
  })
  if ft == "cpp" then
    Utils.append_group(ret, {
      {
        name = "Insert header",
        rtxt = "i",
        cmd = function()
          vim.cmd("Telescope cpptoolkit insert_header")
        end,
      },
      {
        name = "Gen fn impl",
        rtxt = "g",
        cmd = function()
          vim.cmd("CppGenDef")
        end,
      },
    })
  end

  return ret
end

return M
