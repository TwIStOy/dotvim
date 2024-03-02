---@type dora.core.package.PackageOption
return {
  name = "dotvim.packages._",
  deps = {},
  plugins = {},
  setup = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("c", "")
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("r", "")
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("o", "")
      end,
    })
  end,
}
