import { RightClickIndexes } from "@conf/base";
import { Plugin } from "@core/model";

export const plugin = new Plugin({
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
  extends: {
    commands: {
      enabled: (buf) => {
        let [ret] = string.match(buf.fullFileName, ".*%.http");
        return ret !== null;
      },
      rightClick: {
        path: [{ title: "Http", keys: ["h"], index: RightClickIndexes.http }],
      },
      commands: [
        {
          name: "Run the request under cursor",
          callback: () => {
            luaRequire("rest-nvim").run();
          },
          rightClick: {
            title: "Exec request",
            keys: ["r"],
            index: 1,
          },
        },
        {
          name: "Preview the request cURL command",
          callback: () => {
            luaRequire("rest-nvim").run(true);
          },
          rightClick: {
            title: "Preview cURL",
            keys: ["c"],
            index: 2,
          },
        },
        {
          name: "Re-run the last command",
          callback: () => {
            luaRequire("rest-nvim").last();
          },
          rightClick: {
            title: "Re-run last",
            keys: ["l"],
            index: 3,
          },
        },
      ],
    },
  },
});
