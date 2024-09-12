---@type dotvim.core.plugin.PluginOption
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "plenary.nvim",
  },
  keys = function()
    local harpoon = require("harpoon")
    return {
      {
        "<C-m>",
        function()
          harpoon:list():add()
        end,
      },
      {
        "<leader>o",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
      },
      {
        "<C-S-P>",
        function()
          harpoon:list():prev()
        end,
      },
      {
        "<C-S-N>",
        function()
          harpoon:list():next()
        end,
      },
    }
  end,
  opts = { settings = { save_on_toggle = true } },
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<leader>ch", function()
          local keep = {}
          for _, item in ipairs(harpoon:list().items) do
            keep[item.value] = true
          end

          local bufs = vim.api.nvim_list_bufs()
          for _, buf in ipairs(bufs) do
            if
              vim.api.nvim_buf_is_loaded(buf)
              and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "harpoon"
              and vim.api.nvim_get_option_value("buflisted", { buf = buf })
            then
              local f = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":.")

              if vim.api.nvim_get_option_value("modified", { buf = buf }) then
                vim.notify("Not closing " .. f .. " because it is modified")
              elseif not keep[f] then
                vim.api.nvim_buf_delete(buf, { force = false })
                if f == "" then
                  f = "[No Name]"
                end
                vim.notify("Closed buffer: " .. f)
              end
            end
          end
          harpoon.ui:close_menu()
        end, { buffer = cx.bufnr, desc = "Clear non harpoon buffers" })
      end,
    }
  end,
}
