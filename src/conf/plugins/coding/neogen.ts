import {
  ActionBuilder,
  ActionGroupBuilder,
  Plugin,
  andActions,
} from "@core/model";

let group = () =>
  new ActionGroupBuilder()
    .from("neogen")
    .category("Neogen")
    .add(
      ActionBuilder.start()
        .id("neogen.generate-annotation")
        .category("Neogen")
        .condition((buf) => {
          return buf.tsHighlighter.length > 0;
        })
        .from("neogen")
        .title("Generate annotation on this")
        .icon("📝")
        .callback(() => {
          luaRequire("neogen").generate();
        })
        .build()
    );

export const plugin = new Plugin(
  andActions(
    {
      shortUrl: "danymat/neogen",
      lazy: {
        dependencies: ["nvim-treesitter/nvim-treesitter"],
        cmd: ["Neogen"],
        opts: {
          input_after_comment: false,
          snippet_engine: "luasnip",
        },
        config: true,
      },
    },
    () => group().build()
  )
);
