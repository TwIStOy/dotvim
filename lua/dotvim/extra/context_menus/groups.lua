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

function M.build_plugin_harpoon()
  local succ, harpoon = pcall(require, "harpoon")
  if not succ then
    return {}
  end
  local in_harpoon = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    buf_name = vim.fn.fnamemodify(buf_name, ":.")
    for index, item in ipairs(harpoon:list().items) do
      if item.value == buf_name then
        return index
      end
    end
  end

  ---@type dotvim.extra.ContextMenuOption
  local ret = {
    name = "󰒤 Harpoon",
    hl = "ExBlue",
    items = {},
  }

  local index = in_harpoon()
  if index == nil then
    ---@type dotvim.extra.ContextMenuOption
    ret.items[#ret.items + 1] = {
      name = "Add to Harpoon",
      rtxt = "m",
      cmd = function()
        harpoon:list():add()
      end,
    }
  else
    ---@type dotvim.extra.ContextMenuOption
    ret.items[#ret.items + 1] = {
      name = "Remove from Harpoon",
      rtxt = "m",
      cmd = function()
        harpoon:list():remove_at(index)
      end,
    }
  end

  ret.items[#ret.items + 1] = {
    name = "Toggle Harpoon",
    rtxt = "o",
    cmd = function()
      if harpoon:list():length() > 0 then
        harpoon.ui:toggle_quick_menu(harpoon:list())
      else
        vim.notify("No items in Harpoon", "warn")
      end
    end,
  }

  return ret
end

---@return dotvim.extra.ContextMenuOption
function M.build_plugin_conform()
  ---@type dotvim.extra.ContextMenuOption
  return {
    name = "Format buffer",
    rtxt = "<leader>fc",
    cmd = function()
      local conform = require("conform")
      conform.format {
        async = true,
        lsp_fallback = true,
      }
    end,
  }
end

return M
