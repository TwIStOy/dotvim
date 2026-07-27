local Commons = require("dotvim.commons")

---Decides whether Copilot may attach to a buffer. Mirrors copilot.lua's
---default `should_attach` (buflisted + plain buftype) and additionally
---refuses sensitive files (env / secrets) so their contents are never sent.
---@param bufnr integer
---@param bufname string
---@return boolean
local function copilot_should_attach(bufnr, bufname)
  if Commons.fs.is_sensitive_file(bufname) then
    return false
  end
  if not vim.bo[bufnr].buflisted then
    return false
  end
  if vim.bo[bufnr].buftype ~= "" then
    return false
  end
  return true
end

---@type LazyPluginSpec
return {
  "zbirenbaum/copilot.lua",
  enabled = not vim.g.vscode,
  event = "InsertEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    should_attach = copilot_should_attach,
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",
      },
    },
    server_opts_overrides = {
      cmd_env = {
        NODE_TLS_REJECT_UNAUTHORIZED = "0",
      },
    },
  },
  cmd = { "Copilot" },
  config = function(_, opts)
    local setup = function(node_path)
      opts.copilot_node_command = node_path
      require("copilot").setup(opts)

      -- Store current status for lualine component
      local current_status = { status = "", message = "" }

      -- Register status handler for lualine
      local status_mod = require("copilot.status")
      status_mod.register_status_notification_handler(function(data)
        current_status = data
        pcall(require("lualine").refresh)
      end)

      -- Global status getter for lualine
      _G.dotvim_copilot_get_status = function()
        return current_status.status or ""
      end
    end

    vim.defer_fn(function()
      local node_path = vim.fn.exepath("node")

      if node_path and node_path ~= "" then
        setup(node_path)
      else
        -- Try to get node from fish shell
        vim.system({
          "fish",
          "-c",
          "which node",
        }, {
          text = true,
        }, function(obj)
          if obj.code == 0 then
            local path = vim.trim(obj.stdout)
            vim.schedule(function()
              setup(path)
            end)
          else
            vim.notify("Node not found", vim.log.levels.ERROR)
          end
        end)
      end
    end, 100)
  end,
}
