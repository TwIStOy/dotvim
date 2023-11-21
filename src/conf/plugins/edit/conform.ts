import { RightClickIndexes } from "@conf/base";
import { AllFormatters } from "@conf/external_tools";
import { Plugin, PluginOpts } from "@core/model";

let formatters_opts = new LuaTable();
let formatters_by_ft = new LuaTable<AnyNotNil, Array<string>>();

for (let fmt of AllFormatters) {
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

const spec: PluginOpts<[]> = {
  shortUrl: "stevearc/conform.nvim",
  lazy: {
    opts: {
      formatters: formatters_opts,
      formatters_by_ft: formatters_by_ft,
    },
    config: true,
  },
  extends: {
    commands: [
      {
        name: "Format File",
        description: "Format the current file using conform.nvim",
        keys: "<leader>fc",
        shortDesc: "format-file",
        callback() {
          let conform = luaRequire("conform");
          conform.format({
            async: true,
          });
        },
        rightClick: {
          title: "Format File",
          keys: ["c"],
          index: RightClickIndexes.conform,
        },
      },
    ],
  },
};

export default new Plugin(spec);
