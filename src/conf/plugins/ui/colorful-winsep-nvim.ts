import { Plugin } from "@core/plugin";

export default new Plugin({
  shortUrl: "nvim-zh/colorful-winsep.nvim",
  lazy: {
    event: "WinNew",
    config: true,
    opts: {
      create_event: () => {
        let winCount = luaRequire(
          "colorful-winsep.utils"
        ).calculate_number_windows();

        if (winCount === 2) {
          let leftWinId = vim.fn.win_getid(vim.fn.winnr("h"));
          let filetype = vim.api.nvim_get_option_value("filetype", {
            buf: vim.api.nvim_win_get_buf(leftWinId),
          });
          if (filetype === "NvimTree") {
            luaRequire("colorful-winsep").NvimSeparatorDel();
          }
        }
      },
    },
  },
});
