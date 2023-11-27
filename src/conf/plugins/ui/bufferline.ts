import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "akinsho/bufferline.nvim",
  lazy: {
    event: "VeryLazy",
    dependencies: ["nvim-tree/nvim-web-devicons", "catppuccin"],
    config: (_, opts) => {
      vim.schedule(() => {
        luaRequire("bufferline").setup(opts);
      });
    },
    opts: {
      options: {
        view: "multiwindow",
        sort_by: "insert_after_current",
        always_show_bufferline: true,
        themable: true,
        right_mouse_command: null,
        middle_mouse_command: "bdelete! %d",
        indicator: {
          style: "bold",
        },
        hover: { enabled: true, delay: 200 },
        separator_style: "thick",
        close_command: "BDelete! %d",
        numbers: "none",
        diagnostics: "",
        show_buf_icons: false,
        offsets: [
          {
            filetype: "neo-tree",
            text: "File Explorer",
            text_align: "center",
            highlight: "Directory",
          },
          {
            filetype: "NvimTree",
            text: "File Explorer",
            text_align: "center",
            highlight: "Directory",
          },
        ],
        groups: {
          options: {
            toggle_hidden_on_enter: true,
          },
          items: [
            {
              name: "Tests",
              priority: 2,
              icon: "",
              matcher: (buf: any) => {
                let [ret0] = string.match(buf.name, "%_test");
                let [ret1] = string.match(buf.name, "%_spec");
                return ret0 !== null || ret1 !== null;
              },
            },
          ],
        },
      },
    },
  },
  extends: {
    commands: [
      {
        name: "Previous buffer",
        callback: "<cmd>BufferLineCyclePrev<CR>",
        keys: ["<M-,>"],
      },
      {
        name: "Next buffer",
        callback: "<cmd>BufferLineCycleNext<CR>",
        keys: ["<M-.>"],
      },
      {
        name: "Move buffer left",
        callback: "<cmd>BufferLineMovePrev<CR>",
        keys: ["<M-<>"],
      },
      {
        name: "Move buffer right",
        callback: "<cmd>BufferLineMoveNext<CR>",
        keys: ["<M->>"],
      },
    ],
  },
};

export const plugin = new Plugin(spec);
