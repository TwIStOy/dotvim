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
      format_after_save: {
        lsp_fallback: true,
      },
      // format_on_save: {
      //   lsp_fallback: false,
      //   timeout_ms: 500,
      // },
    },
    event: "BufReadPost",
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

export const plugin = new Plugin(
  andActions(spec, () => {
    return new ActionGroupBuilder()
      .from("conform")
      .category("Conform")
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
