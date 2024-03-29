---@type dora.core.plugin.PluginOption[]
return {
  {
    "folke/noice.nvim",
    event = { "ModeChanged", "BufReadPre", "InsertEnter" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        progress = {
          enabled = true,
          throttle = 1000 / 10,
          view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
        hover = {
          enabled = true,
          opts = {
            border = { style = "none", padding = { 1, 2 } },
            position = { row = 2, col = 2 },
          },
        },
      },
      messages = { enabled = false },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      local Format = require("noice.lsp.format")
      local Hacks = require("noice.util.hacks")

      local function from_lsp_clangd(e)
        return vim.tbl_get(e, "source", "name") == "nvim_lsp"
          and vim.tbl_get(e, "source", "source", "client", "name") == "clangd"
      end

      Hacks.on_module("cmp.entry", function(mod)
        mod.get_documentation = function(self)
          local item = self:get_completion_item()

          local lines = item.documentation
              and Format.format_markdown(item.documentation)
            or {}
          local ret = table.concat(lines, "\n")
          local detail = item.detail
          if detail and type(detail) == "table" then
            detail = table.concat(detail, "\n")
          end

          if from_lsp_clangd(self) then
            local label_details = item.labelDetails
            if
              label_details
              and type(label_details) == "table"
              and label_details.detail
            then
              if detail == nil then
                detail = ""
              end
              detail = detail .. label_details.detail
            end
          end

          if detail and not ret:find(detail, 1, true) then
            local ft = self.context.filetype
            local dot_index = string.find(ft, "%.")
            if dot_index ~= nil then
              ft = string.sub(ft, 0, dot_index - 1)
            end
            ret = ("```%s\n%s\n```\n%s"):format(ft, vim.trim(detail), ret)
          end
          return vim.split(ret, "\n")
        end
      end)
    end,
    actions = function()
      ---@type dora.core.action
      local action = require("dora.core.action")

      return action.make_options {
        from = "noice.nvim",
        category = "Noice",
        actions = {
          {
            id = "noice.show-message-history",
            title = "Shows the message history",
            callback = "Noice history",
          },
          {
            id = "noice.show-last-message",
            title = "Shows the last message in a popup",
            callback = "Noice last",
          },
          {
            id = "noice.dismiss-all-messages",
            title = "Dismiss all visible messages",
            callback = "Noice dismiss",
          },
          {
            id = "noice.disable",
            title = "Disables Noice",
            callback = "Noice disable",
          },
          {
            id = "noice.enable",
            title = "Enables Noice",
            callback = "Noice enable",
          },
          {
            id = "noice.show-stats",
            title = "Show debugging stats",
            callback = "Noice stats",
          },
          {
            id = "noice.show-message-history-in-telescope",
            title = "Opens message history in Telescope",
            callback = "Noice telescope",
          },
          {
            id = "noice.show-errors",
            title = "Shows the error messages in a split",
            callback = "Noice errors",
          },
        },
      }
    end,
  },
}
