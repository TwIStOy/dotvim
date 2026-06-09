{pkgs, lib, utils, ...}: let
  lua = utils.lua {inherit lib;};
in {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "close-buffers-nvim";
      doCheck = false;
      src = pkgs.fetchFromGitHub {
        owner = "kazhala";
        repo = "close-buffers.nvim";
        rev = "0.1.1";
        hash = "sha256-7k5mzeCraendGxp5eeyVBttLKcyMMAnc2I6JCivG150=";
      };
    })
  ];

  extraConfigLua = ''
    require("close_buffers").setup({
      filetype_ignore = {
        "dashboard",
        "NvimTree",
        "TelescopePrompt",
        "terminal",
        "toggleterm",
        "packer",
        "fzf",
      },
      preserve_window_layout = { "this" },
      next_buffer_cmd = function(windows)
        require("bufferline").cycle(1)
        local bufnr = vim.api.nvim_get_current_buf()
        for _, window in ipairs(windows) do
          vim.api.nvim_win_set_buf(window, bufnr)
        end
      end,
    })

    vim.keymap.set({"n", "v"}, "<leader>ch", function()
      require("close_buffers").delete({ type = "hidden", force = true })
      vim.api.nvim_command("redrawstatus!")
      vim.api.nvim_command("redraw!")
    end, { desc = "delete-hidden-buffers" })
  '';
}
