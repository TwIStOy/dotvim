import { AllFormatters } from "@conf/external_tools";
import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

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
    event: "BufReadPost",
    config: true,
    cmd: ["ConformInfo"],
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

const NoFormatFileTypes = new Set(["alpha", "neo-tree"]);

export const plugin = new Plugin(
  andActions(spec, () => {
    return new ActionGroupBuilder()
      .from("conform")
      .category("Conform")
      .condition((buf) => {
        return !NoFormatFileTypes.has(buf.filetype);
      })
      .addOpts({
        id: "conform.format",
        title: "Format File",
        description: "Format the current file using conform.nvim",
        keys: [{ [1]: "<leader>fc", desc: "format-file" }],
        callback() {
          let conform = luaRequire("conform");
          conform.format({
            async: true,
          });
        },
      })
      .build();
  })
);
