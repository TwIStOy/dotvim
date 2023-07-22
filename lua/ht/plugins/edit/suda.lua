return {
  {
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = {
      "SudaRead",
      "SudaWrite",
    },
    init = function()
      vim.g["suda#nopass"] = 1
    end,
  },
}
