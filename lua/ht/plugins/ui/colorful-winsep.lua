return {
  -- colorful windows seperators
  {
    "nvim-zh/colorful-winsep.nvim",
    event = {
      "WinNew",
    },
    config = true,
    opts = {
      create_event = function()
        local win_n =
          require("colorful-winsep.utils").calculate_number_windows()
        local colorful_winsep = require("colorful-winsep")

        if win_n == 2 then
          local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
          local filetype = vim.api.nvim_buf_get_option(
            vim.api.nvim_win_get_buf(win_id),
            "filetype"
          )
          if filetype == "NvimTree" then
            colorful_winsep.NvimSeparatorDel()
          end
        end
      end,
    },
  },
}
