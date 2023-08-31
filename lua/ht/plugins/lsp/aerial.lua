---@class aerial.ParseSymbolContext
---@field backend_name  "treesitter"|"lsp"|"markdown"|"man"
---@field lang string
---@field symbols any? specific to the lsp backend
---@field symbol any? specific to the lsp backend
---@field syntax_tree any? specific to the treesitter backend
---@field match any? specific to the treesitter backend, TS query match

---@class aerial.AddAllSymbolContext
---@field backend_name  "treesitter"|"lsp"|"markdown"|"man"
---@field lang string
---@field symbols any? specific to the lsp backend
---@field syntax_tree any? specific to the treesitter backend

---@param bufnr number
---@param item aerial.Symbol
---@param ctx aerial.ParseSymbolContext
local post_parse_symbol = function(bufnr, item, ctx)
  -- merge nested namespaces
  ---@param _item aerial.Symbol
  local function merge_nested_namespaces(_item)
    if
      _item.kind == "Namespace"
      and #_item.children == 1
      and _item.children[1].kind == "Namespace"
      and _item.lnum == _item.children[1].lnum
      and _item.end_lnum == _item.children[1].end_lnum
    then
      _item.name = _item.name .. "::" .. _item.children[1].name
      _item.children = _item.children[1].children
      for _, child in ipairs(_item.children) do
        child.parent = _item
        child.level = _item.level + 1
      end
      merge_nested_namespaces(_item)
    end
  end

  if ctx.backend_name == "lsp" and ctx.lang == "clangd" then
    -- try to merge nested namespaces
    merge_nested_namespaces(item)
  end
  return true
end

return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "TwIStOy/telescope.nvim",
    },
    cmd = {
      "AerialToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialClose",
      "AerialCloseAll",
      "AerialNext",
      "AerialPrev",
      "AerialGo",
      "AerialInfo",
      "AerialNavToggle",
      "AerialNavOpen",
      "AerialNavClose",
    },
    lazy = true,
    opts = {
      backends = { "lsp", "markdown", "man" },
      layout = {
        default_direction = "right",
        placement = "edge",
        preserve_equality = true,
      },
      attach_mode = "global",
      filter_kind = false,
      post_parse_symbol = post_parse_symbol,
      show_guides = true,
    },
    config = function(_, opts)
      require("aerial").setup(opts)
      require("telescope").load_extension("aerial")
    end,
    keys = {
      {
        "<Char-0xAD>",
        function()
          vim.cmd("AerialToggle")
        end,
      },
    },
  },
}
