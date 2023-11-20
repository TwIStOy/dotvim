import { Plugin } from "@core/model";

export default new Plugin({
  shortUrl: "abecodes/tabout.nvim",
  lazy: {
    event: "InsertEnter",
    dependencies: ["nvim-treesitter/nvim-treesitter"],
    opts: {
      tabouts: [
        { open: "'", close: "'" },
        { open: '"', close: '"' },
        { open: "`", close: "`" },
        { open: "(", close: ")" },
        { open: "[", close: "]" },
        { open: "{", close: "}" },
        { open: "<", close: ">" },
      ],
    },
    config: true,
    keys: [
      {
        [1]: "<M-x>",
        [2]: "<Plug>(TaboutMulti)",
        mode: "i",
        silent: true,
      },
      {
        [1]: "<M-z>",
        [2]: "<Plug>(TaboutBackMulti)",
        mode: "i",
        silent: true,
      },
    ],
  },
});
