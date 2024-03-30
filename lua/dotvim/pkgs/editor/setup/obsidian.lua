local Shared = require("dotvim.pkgs.editor.shared")

return function()
  local au_group =
    vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })

  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufWinEnter" }, {
    group = au_group,
    pattern = Shared.vault_dir() .. "/**.md",
    callback = function()
      vim.wo.conceallevel = 2
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          vim.api.nvim_command("ObsidianFollowLink")
        end
      end, { buffer = true, desc = "obsidian-follow-link" })
    end,
  })
end
