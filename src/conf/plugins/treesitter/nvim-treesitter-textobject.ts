import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "nvim-treesitter/nvim-treesitter-textobjects",
  lazy: {
    event: ["BufReadPost", "BufNewFile"],
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    opts: {
      textobjects: {
        select: {
          enable: true,
          lookahead: true,
          keymaps: {
            ["af"]: "@function.outer",
            ["if"]: "@function.inner",
            ["i,"]: "@parameter.inner",
            ["a,"]: "@parameter.outer",
            ["i:"]: "@assignment.rhs",
            ["il"]: "@lifetime.inner",
            ["a;"]: "@statement.outer",
            ["ir"]: "@super_right.inner",
          },
        },
        swap: {
          enable: true,
          swap_next: {
            ["<M-l>"]: "@parameter.inner",
          },
          swap_previous: {
            ["<M-h>"]: "@parameter.inner",
          },
        },
        move: {
          enable: true,
          set_jumps: true,
          goto_next_start: {
            ["],"]: "@parameter.inner",
            ["]l"]: "@lifetime.inner",
            ["]f"]: "@function.outer",
            ["]r"]: "@super_right.inner",
          },
          goto_previous_start: {
            ["[,"]: "@parameter.inner",
            ["[l"]: "@lifetime.inner",
            ["[f"]: "@function.outer",
            ["[r"]: "@super_right.inner",
          },
        },
      },
    },
    config: (_, opts) => {
      luaRequire("nvim-treesitter.configs").setup(opts);
    },
  },
    allowInVscode: true,
  extends: {
    commands: {
      category: "Textobject",
      enabled: (buffer) => {
        return buffer.tsHighlighter.length > 0;
      },
      commands: [
        {
          name: "Swap previous",
          callback: () => {
            luaRequire("nvim-treesitter.textobjects.swap").swap_previous(
              "@parameter.inner"
            );
          },
          rightClick: {
            title: "Swap previous",
            keys: [","],
            index: 1,
          },
        },
        {
          name: "Swap next",
          callback: () => {
            luaRequire("nvim-treesitter.textobjects.swap").swap_next(
              "@parameter.inner"
            );
          },
          rightClick: {
            title: "Swap next",
            keys: ["."],
            index: 2,
          },
        },
      ],
    },
  },
};

export const plugin = new Plugin(spec);
