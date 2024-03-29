import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts<[]> = {
  shortUrl: "numToStr/Comment.nvim",
  lazy: {
    dependencies: ["JoosepAlviste/nvim-ts-context-commentstring"],
    keys: [
      { [1]: "gcc", [2]: null, desc: "toggle-line-comment" },
      { [1]: "gcc", [2]: null, mode: "x", desc: "toggle-line-comment" },
      { [1]: "gbc", [2]: null, desc: "toggle-block-comment" },
      { [1]: "gbc", [2]: null, mode: "x", desc: "toggle-block-comment" },
    ],
    opts: {
      toggler: {
        line: "gcc",
        block: "gbc",
      },
      opleader: {
        line: "gcc",
        block: "gbc",
      },
      mappings: {
        basic: true,
        extra: false,
      },
      pre_hook: () => {
        luaRequire(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook();
      },
    },
    config: true,
  },
  allowInVscode: true,
};

export const plugin = new Plugin(spec);
