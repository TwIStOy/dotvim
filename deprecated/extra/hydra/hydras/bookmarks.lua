---@type dotvim.extra.hydra.CreateHydraOpts
return {
  body = "<C-b>",
  mode = "n",
  config = {
    color = "pink",
    hint = {
      type = "window",
      position = { "middle" },
      show_name = true,
    },
    invoke_on_body = true,
  },
  heads = {
    l = {
      function()
        vim.api.nvim_command("Telescope bookmarks")
      end,
      { desc = "list-bookmarks", silent = true },
    },
    t = {
      function()
        require("bookmarks").toggle_bookmarks()
      end,
      { desc = "toggle-bookmarks", silent = true },
    },
    n = {
      function()
        require("bookmarks").add_bookmarks()
      end,
      { desc = "add-bookmark", silent = true },
    },
    d = {
      function()
        require("bookmarks.list").delete_on_virt()
      end,
      { desc = "delete-at-virt-line", silent = true },
    },
    s = {
      function()
        require("bookmarks.list").show_desc()
      end,
      { desc = "show-bookmark-desc", silent = true },
    },
    ["<Esc>"] = { nil, { exit = true } },
  },
}
