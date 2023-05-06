local RightClick = require("ht.core.right-click")
local call_once = require("ht.utils.func").call_once
local FF = require("ht.core.functions")

local function setup()
  RightClick.add_section {
    index = RightClick.indexes.rust_tools,
    enabled = {
      filetype = "rust",
    },
    items = {
      {
        "Rust",
        keys = "R",
        children = {
          {
            "Hover Actions",
            callback = function()
              require("rust-tools").hover_actions.hover_actions()
            end,
          },
          {
            "Open Cargo",
            callback = function()
              require("rust-tools").open_cargo_toml.open_cargo_toml()
            end,
            keys = "c",
            desc = "open project Cargo.toml",
          },
          {
            "Move Item Up",
            callback = function()
              require("rust-tools").move_item.move_item(true)
            end,
          },
          {
            "Expand Macro",
            callback = function()
              require("rust-tools").expand_macro.expand_macro()
            end,
            desc = "expand macros recursively",
            keys = { "e", "E" },
          },
          {
            "Parent Module",
            callback = function()
              require("rust-tools").parent_module.parent_module()
            end,
            keys = "p",
          },
          {
            "Join Lines",
            callback = function()
              require("rust-tools").join_lines.join_lines()
            end,
          },
        },
      },
    },
  }
end

return call_once(setup)
