local Commons = require("dotvim.commons")

---@type LazyPluginSpec
return {
  "saghen/blink.pairs",
  build = (function()
    if Commons.nix.in_nix_env() then
      return "nix run .#build-plugin"
    else
      return "cargo build --release"
    end
  end)(),
  version = "*",
  event = "VeryLazy",
  opts = {
    highlights = {
      enabled = true,
    },
    mappings = {
      pairs = {
        ['"'] = {
          {
            'r#"',
            '"#',
            languages = { "rust" },
            priority = 100,
          },
          {
            '"""',
            when = function(ctx)
              return ctx:text_before_cursor(2) == '""'
            end,
            languages = { "python", "elixir", "julia", "kotlin", "scala" },
          },
          {
            '"',
            enter = false,
            space = false,
            when = function(ctx)
              return ctx:text_before_cursor(1) ~= "#"
            end,
          },
        },
        ["<"] = {
          {
            "<",
            ">",
            when = function(ctx)
              return ctx.ts:whitelist("angle").matches
            end,
            languages = { "rust" },
          },
          {
            "<",
            ">",
            when = function(ctx)
              local text_before_cursor = ctx:text_before_cursor(1)
              return text_before_cursor ~= "#"
                and text_before_cursor ~= " "
                and text_before_cursor ~= "<"
            end,
            languages = { "cpp" },
          },
        },
      },
    },
  },
}
