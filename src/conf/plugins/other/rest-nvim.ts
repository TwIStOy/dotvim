import { RightClickIndexes } from "@conf/base";
import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

function generateActions() {
  return ActionGroupBuilder.start()
    .from("rest.nvim")
    .category("Rest")
    .condition((buf) => {
      let [ret] = string.match(buf.fullFileName, ".*%.http");
      return ret !== null;
    })
    .addOpts({
      id: "rest-nvim.run-request",
      title: "Run the request under cursor",
      callback: () => {
        luaRequire("rest-nvim").run();
      },
    })
    .addOpts({
      id: "rest-nvim.preview-curl-command",
      title: "Preview the request cURL command",
      callback: () => {
        luaRequire("rest-nvim").run(true);
      },
    })
    .addOpts({
      id: "rest-nvim.rerun-last-command",
      title: "Re-run the last command",
      callback: () => {
        luaRequire("rest-nvim").last();
      },
    })
    .build();
}

const spec: PluginOptsBase = {
  shortUrl: "rest-nvim/rest.nvim",
  lazy: {
    opts: {
      skip_ssl_verification: true,
    },
    ft: ["http"],
    lazy: true,
    dependencies: ["nvim-lua/plenary.nvim"],
    config: (_, opts) => {
      luaRequire("rest-nvim").setup(opts);
    },
  },
  allowInVscode: true,
};

export const plugin = new Plugin(andActions(spec, generateActions));
