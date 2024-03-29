local formatter = require("ht.core.external_tool").formatter

---@type ht.external_tool.Formatter[]
local formatters = {}

formatters[#formatters + 1] = formatter.new(
  "c,cpp,cs,java,cuda,proto",
  "clang-format",
  {
    args = { "-style=file" },
    stdin = true,
  },
  {
    name = "clang-format",
  }
)

-- TODO(hawtian): stylua condition,
--       condition = function(utils)
--         return utils.root_has_file { "stylua.toml", ".stylua.toml" }
--       end,
formatters[#formatters + 1] = formatter.new("lua", "stylua", {
  args = { "--search-parent-directories", "-" },
  stdin = true,
}, {
  name = "stylua",
})

formatters[#formatters + 1] = formatter.new("rust", "rustfmt", {
  args = { "--emit", "stdout" },
  stdin = true,
}, {
  name = "rustfmt",
  mason = false,
})

formatters[#formatters + 1] = formatter.new(
  "javascript,javascriptreact,typescript,typescriptreact,vue,css,scss,less,html,json,jsonc,yaml,markdown,markdown.mdx,graphql,handlebars",
  "prettier",
  {
    args = { "--stdin-filepath", "--prose-wrap", "never" },
    stdin = true,
    fname = true,
  },
  {
    name = "prettier",
  }
)

formatters[#formatters + 1] = formatter.new("python", "black", {
  args = { "--quiet", "-" },
  stdin = true,
  find = "pyproject.toml",
}, {
  name = "black",
})

formatters[#formatters + 1] = formatter.new("dart", "dart", {
  args = { "format" },
  stdin = true,
}, {
  name = "dart",
  mason = false,
})

formatters[#formatters+1] = formatter.new("cmake", "gersemi", {
  args = { "-" },
  stdin = true,
}, {
  name = "gersemi"
})

return formatters
