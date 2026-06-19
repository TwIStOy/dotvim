_: {
  extraConfigLuaPre = ''
    if vim.g.neovide then
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          vim.g.neovide_opacity = 1
          vim.g.neovide_normal_opacity = 0.5
          vim.g.neovide_window_blurred = true
          vim.g.neovide_floating_blur_amount_x = 2.0
          vim.g.neovide_floating_blur_amount_y = 2.0
          vim.g.neovide_floating_corner_radius = 0.1
          vim.g.neovide_floating_shadow = true
          vim.opt.winblend = 20
          vim.opt.pumblend = 20
        end,
      })
    end
  '';

  extraConfigLua = ''
    if vim.g.neovide then
      local function save() vim.cmd.write() end
      local function copy() vim.cmd([[normal! "+y]]) end
      local function paste() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end

      vim.keymap.set({ "n", "i", "v" }, "<D-s>", save, { desc = "Save" })
      vim.keymap.set("v", "<D-c>", copy, { silent = true, desc = "Copy" })
      vim.keymap.set({ "n", "i", "v", "c", "t" }, "<D-v>", paste, { silent = true, desc = "Paste" })
    end
  '';
}
