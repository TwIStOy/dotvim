import { ActionGroupBuilder, Plugin } from "@core/model";

export default new Plugin({
  shortUrl: "danymat/neogen",
  lazy: {
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    cmd: ["Neogen"],
    opts: {
      input_after_comment: false,
    },
    config: true,
  },
  providedActions() {
    let group = new ActionGroupBuilder()
      .category("Neogen")
      .condition((buf) => {
        return buf.tsHighlighter.length > 0;
      })
      .from("neogen");

    group.addOpts({
      id: "neogen.generate-annotation",
      title: "Generate annotation on this",
      icon: "📝",
      callback: () => {
        luaRequire("neogen").generate();
      },
    });

    return group.build();
  },
});
