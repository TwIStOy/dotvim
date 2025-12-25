---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    select = {
      lookahead = true,
      selection_modes = {},
    },
    include_surrounding_whitespace = true,
    move = {
      set_jumps = true,
    },
  },
  ---@return LazyKeysSpec[]
  keys = function()
    ---@return LazyKeysSpec
    local def_select = function(key, query)
      local desc = query:gsub("@", ""):gsub("%.", "_"):gsub(":", "_")
      return {
        key,
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            query,
            "textobjects"
          )
        end,
        desc = "select-" .. desc,
        mode = { "o", "x" },
      }
    end
    ---@return LazyKeysSpec
    local move_next = function(key, query)
      local desc = query:gsub("@", ""):gsub("%.", "_"):gsub(":", "_")
      return {
        key,
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start(
            query,
            "textobjects"
          )
        end,
        desc = "goto-next-" .. desc,
        mode = { "n", "o", "x" },
      }
    end
    ---@return LazyKeysSpec
    local move_prev = function(key, query)
      local desc = query:gsub("@", ""):gsub("%.", "_"):gsub(":", "_")
      return {
        key,
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            query,
            "textobjects"
          )
        end,
        desc = "goto-previous-" .. desc,
        mode = { "n", "o", "x" },
      }
    end
    return {
      def_select("af", "@function.outer"),
      def_select("if", "@function.inner"),
      def_select("i,", "@parameter.inner"),
      def_select("a,", "@parameter.outer"),
      def_select("i:", "@assignment.rhs"),
      def_select("il", "@lifetime.inner"),
      def_select("a;", "@statement.outer"),
      def_select("ir", "@dotvim_omni_right.inner"),
      def_select("ic", "@conditional.inner"),
      def_select("ac", "@conditional.outer"),
      {
        "<leader>a",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next(
            "@parameter.inner"
          )
        end,
        desc = "swap-next-parameter",
        mode = { "n" },
      },
      {
        "<leader>A",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous(
            "@parameter.outer"
          )
        end,
        desc = "swap-previous-parameter",
        mode = { "n" },
      },
      move_next("],", "@parameter.inner"),
      move_next("]l", "@lifetime.inner"),
      move_next("]f", "@function.outer"),
      move_next("]r", "@dotvim_omni_right.inner"),
      move_prev("[,", "@parameter.inner"),
      move_prev("[l", "@lifetime.inner"),
      move_prev("[f", "@function.outer"),
      move_prev("[r", "@dotvim_omni_right.inner"),
    }
  end,
}
