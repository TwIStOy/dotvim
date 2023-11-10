import { Plugin, PluginOpts } from "../../../core/plugin";
import formatters from "../../external_tools/formatters";

let formatters_opts = new LuaTable();
let formatters_by_ft = new LuaTable<AnyNotNil, Array<string>>();

for (let fmt of formatters) {
  formatters_opts.set(fmt.name, fmt.asConformSpec());
  if (fmt.ft) {
    if (typeof fmt.ft === "string") {
      formatters_by_ft.set(fmt.ft, [fmt.name]);
    } else {
      for (let ft of fmt.ft) {
        if (formatters_by_ft.has(ft)) {
          formatters_by_ft.get(ft).push(fmt.name);
        }
        formatters_by_ft.set(ft, [fmt.name]);
      }
    }
  }
}

const spec: PluginOpts = {
  shortUrl: "stevearc/conform.nvim",
  lazy: {
    opts: {
      formatters: formatters_opts,
      formatters_by_ft: formatters_by_ft,
    },
    config: true,
    keys: [
      {
        [1]: "<leader>fc",
        [2]: () => {
          let conform = luaRequire("conform");
          conform.format({
            async: true,
          });
        },
        desc: "format-file",
      },
    ],
  },
};

export default new Plugin(spec);
