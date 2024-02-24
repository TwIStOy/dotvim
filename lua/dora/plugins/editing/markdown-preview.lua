local core = {
  action = require("dora.core.action"),
}

---@type dora.core.PluginOptions
return {
  "iamcco/markdown-preview.nvim",
  nixpkg = "markdown-preview-nvim",
  ft = { "markdown" },
  build = function()
    vim.api.nvim_command("call mkdp#util#install()")
  end,
  init = function()
    vim.g.mkdp_open_to_the_world = true
    vim.g.mkdp_echo_preview_url = true
  end,
  actions = core.make_options {
    from = "markdown-preview.nvim",
    category = "MdPreview",
    ---@param buffer dora.lib.vim.Buffer
    condition = function(buffer)
      return buffer.filetype == "markdown"
    end,
    ---@type dora.core.ActionOptions[]
    actions = {
      {
        id = "markdown-preview.start",
        title = "Start md preview",
        callback = "MarkdownPreview",
      },
      {

        id = "markdown-preview.stop",
        title = "Stop md preview",
        callback = "MarkdownPreviewStop",
      },
      {
        id = "markdown-preview.toggle",
        title = "Toggle md preview",
        callback = "MarkdownPreviewToggle",
      },
    },
  },
}
