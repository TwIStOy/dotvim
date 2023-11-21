import { Plugin, PluginOpts } from "@core/model";
import { isNil, redrawAll } from "@core/vim";

const spec: PluginOpts = {
  shortUrl: "kazhala/close-buffers.nvim",
  lazy: {
    cmd: ["BDelete", "BWipeout"],
    config: () => {
      luaRequire("close_buffers").setup({
        filetype_ignore: [
          "dashboard",
          "NvimTree",
          "TelescopePrompt",
          "terminal",
          "toggleterm",
          "packer",
          "fzf",
        ],
        preserve_window_layout: ["this"],
        next_buffer_cmd: (windows: number[]) => {
          luaRequire("bufferline").cycle(1);
          let bufnr = vim.api.nvim_get_current_buf();
          for (let window of windows) {
            vim.api.nvim_win_set_buf(window, bufnr);
          }
        },
      });
    },
  },
  extends: {
    commands: {
      category: "CloseBuffer",
      commands: [
        {
          name: "Delete all non-visible buffers",
          callback: () => {
            luaRequire("close_buffers").delete({ type: "hidden", force: true });
            redrawAll();
          },
          keys: "<leader>ch",
          shortDesc: "clear-hidden-buffers",
        },
        {
          name: "Delete all buffers without name",
          callback: () => {
            luaRequire("close_buffers").delete({ type: "nameless" });
            redrawAll();
          },
        },
        {
          name: "Delete the current buffer",
          callback: () => {
            luaRequire("close_buffers").delete({ type: "this" });
            redrawAll();
          },
        },
        {
          name: "Delete all buffers matching the regex",
          callback: () => {
            vim.ui.input({ prompt: "Regex" }, (input) => {
              if (!isNil(input)) {
                if (input.length > 0) {
                  luaRequire("close_buffers").delete({ regex: input });
                }
              }
            });
            redrawAll();
          },
        },
      ],
    },
  },
};

export const plugin = new Plugin(spec);
