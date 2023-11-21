import { ActionBuilder, Plugin, PluginOpts } from "@core/model";

function showNabla() {
  luaRequire("nabla").popup({
    border: "solid",
  });
}

const spec: PluginOpts<["nabla.show-nabla"]> = {
  shortUrl: "jbyuki/nabla.nvim",
  lazy: {
    ft: ["latex", "markdown"],
    config: true,
    keys: [
      {
        [1]: "<leader>pf",
        [2]: showNabla,
        ft: ["latex", "markdown"],
      },
    ],
  },
  providedActions: [
    ActionBuilder.start()
      .id("nabla.show-nabla")
      .title("Show Nabla")
      .condition((buf) => {
        return buf.filetype === "latex" || buf.filetype === "markdown";
      })
      .callback(() => {
        luaRequire("nabla").popup({
          border: "solid",
        });
      })
      .from("nabla.nvim")
      .category("Nabla")
      .build(),
  ],
};

export default new Plugin(spec);
