local function t_cmd(s, cmd, keys)
  return {
    s,
    callback = function()
      vim.cmd(cmd)
    end,
    keys = keys,
  }
end

return {
  {
    "TwIStOy/cpp-toolkit.nvim",
    config = function()
      require("cpp-toolkit").setup {
        impl_return_type_style = "trailing",
      }

      require("telescope").load_extension("cpptoolkit")
      require("ht.core.functions"):add_function_set {
        category = "CppToolkit",
        ft = { "cpp", "c" },
        functions = {
          {
            title = "Fuzzy find header and insert",
            f = function()
              vim.cmd("Telescope cpptoolkit insert_header")
            end,
          },
          {
            title = "Generate function implementation body",
            f = function()
              vim.cmd("CppGenDef")
            end,
          },
        },
      }

      local RightClick = require("ht.core.right-click")
      RightClick.add_section {
        index = RightClick.indexes.cpp_toolkit,
        enabled = {
          filetype = {
            "cpp",
            "c",
          },
        },
        items = {
          {
            "CppToolkit",
            keys = "c",
            children = {
              t_cmd(
                "Fuzzy insert header",
                "Telescope cpptoolkit insert_header",
                "h"
              ),
              t_cmd("Debug &print", "CppDebugPrint"),
              t_cmd("Generate &impl", "CppGenDef"),
              t_cmd("Move value", "CppToolkit shortcut move_value", "m"),
              t_cmd("Forward value", "CppToolkit shortcut forward_value", "f"),
            },
          },
        },
      }
    end,
    ft = { "cpp", "c" },
    cmd = { "CppGenDef", "CppDebugPrint", "CppToolkit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "TwIStOy/right-click.nvim",
    },
    keys = {
      {
        "<M-g><M-i>",
        function()
          require("telescope").extensions.cpptoolkit.insert_header {
            prompt_prefix = "🔍 ",
          }
        end,
        desc = "insert-header",
        mode = { "i", "n" },
      },
      {
        "<M-g><M-m>",
        function()
          require("cpp-toolkit.functions.shortcut").shortcut_move_value()
        end,
        desc = "move-value",
        mode = { "n" },
      },
      {
        "<M-g><M-f>",
        function()
          require("cpp-toolkit.functions.shortcut").shortcut_forward_value()
        end,
        desc = "forward-value",
        mode = { "n" },
      },
    },
  },
}
