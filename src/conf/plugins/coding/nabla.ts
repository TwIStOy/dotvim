import { Plugin, PluginOpts } from "@core/model";

function showNabla() {
  luaRequire("nabla").popup({
    border: "solid",
  });
}

const spec: PluginOpts = {
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
};

export default new Plugin(spec);
