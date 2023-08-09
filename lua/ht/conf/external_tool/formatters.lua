local formatter = require("ht.core.external_tool").formatter

---@type ht.external_tool.Formatter[]
local formatters = {}

formatters[#formatters + 1] = formatter.new("c,cpp", "clang-format", {
  args = { "-style=file" },
  stdin = true,
}, {
  name = "clang-format",
})

-- TODO(hawtian): stylua condition,
--       condition = function(utils)
--         return utils.root_has_file { "stylua.toml", ".stylua.toml" }
--       end,
formatters[#formatters + 1] = formatter.new("lua", "stylua", {
  args = { "-" },
  stdin = true,
}, {
  name = "stylua",
})

formatters[#formatters + 1] = formatter.new("rust", "rustfmt", {
  args = { "--edition", "2021", "--emit", "stdout" },
  stdin = true,
}, {
  name = "rustfmt",
})

formatters[#formatters + 1] = formatter.new(
  "javascript,javascriptreact,typescript,typescriptreact,vue,css,scss,less,html,json,jsonc,yaml,markdown,markdown.mdx,graphql,handlebars",
  "prettier",
  {
    args = { "--stdin-filepath" },
    stdin = true,
    fname = true,
  },
  {
    name = "prettier",
  }
)

formatters[#formatters + 1] = formatter.new("python", "black", {
  args = { "-" },
  stdin = true,
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

return formatters
