return {
  -- templates
  {
    "aperezdc/vim-template",
    cmd = { "Template", "TemplateHere" },
    enabled = function()
      if vim.g["neovide"] or vim.g["fvim_loaded"] then
        return false
      end
      return true
    end,
    init = function()
      vim.g.templates_directory = {
        os.getenv("HOME") .. [[/.dotvim/vim-templates]],
      }
      vim.g.templates_no_autocmd = 0
      vim.g.templates_debug = 0
      vim.g.templates_no_builtin_templates = 1
    end,
  },
}
