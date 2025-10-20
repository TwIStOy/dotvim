local Commons = require("dotvim.commons")

local function get_installed_plugin_path(plug)
  return _G["dotvim_lazyroot"] .. "/" .. plug
end

---@type LazyPluginSpec[]
return {
  {
    "TwIStOy/blink.pairs",
    build = (function()
      if Commons.nix.in_nix_env() then
        return {
          ("cp %s %s"):format(
            os.getenv("HOME") .. "/.dotvim/patches/blink.flake.lock",
            get_installed_plugin_path("blink.pairs") .. "/flake.lock"
          ),
          "nix run .#build-plugin --accept-flake-config --extra-experimental-features flakes --extra-experimental-features nix-command",
        }
      else
        return "cargo build --release"
      end
    end)(),
    opts = {
      highlights = {
        enabled = false,
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
  },
  {
    "xzbdmw/clasp.nvim",
    opts = {},
    keys = {
      {
        "<M-[>",
        mode = { "i", "n" },
        desc = "Wrap previous",
        function()
          require("clasp").wrap("prev")
        end,
      },
      {
        "<M-]>",
        mode = { "i", "n" },
        desc = "Wrap next",
        function()
          require("clasp").wrap("next")
        end,
      },
    },
  },
  {
    "abecodes/tabout.nvim",
    lazy = false,
    opts = {},
  },
}
