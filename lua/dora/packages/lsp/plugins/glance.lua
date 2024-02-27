---@type dora.core.plugin.PluginOption
return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  opts = function()
    local actions = require("glance").actions
    return {
      detached = function(winid)
        return vim.api.nvim_win_get_width(winid) < 100
      end,
      preview_win_opts = { cursorline = true, number = true, wrap = false },
      border = { disable = true, top_char = "―", bottom_char = "―" },
      theme = { enable = true },
      list = { width = 0.2 },
      mappings = {
        list = {
          ["j"] = actions.next,
          ["k"] = actions.previous,
          ["<Down>"] = false,
          ["<Up>"] = false,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = false,
          ["s"] = false,
          ["t"] = false,
          ["<CR>"] = actions.jump,
          ["o"] = false,
          ["<leader>l"] = false,
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
        },
        preview = {
          ["Q"] = actions.close,
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["<leader>l"] = false,
        },
      },
      folds = { fold_closed = "󰅂", fold_open = "󰅀", folded = false },
      indent_lines = { enable = false },
      winbar = { enable = true },
      hooks = function(results, open, jump, method)
        if method == "references" or method == "implementations" then
          open(results)
        elseif #results == 1 then
          jump(results[1])
        else
          open(results)
        end
      end,
    }
  end,
}
