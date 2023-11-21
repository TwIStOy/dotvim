import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

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
};

function generateActions() {
  return ActionGroupBuilder.start()
    .from("nvim-treesitter-textobjects")
    .category("TSTextObjects")
    .condition((buf) => {
      return buf.tsHighlighter.length > 0;
    })
    .addOpts({
      id: "treesitter-textobjects.swap-previous",
      title: "Swap previous",
      callback: () => {
        luaRequire("nvim-treesitter.textobjects.swap").swap_previous(
          "@parameter.inner"
        );
      },
      keys: ",",
    })
    .addOpts({
      id: "treesitter-textobjects.swap-next",
      title: "Swap next",
      callback: () => {
        luaRequire("nvim-treesitter.textobjects.swap").swap_next(
          "@parameter.inner"
        );
      },
      keys: ".",
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
