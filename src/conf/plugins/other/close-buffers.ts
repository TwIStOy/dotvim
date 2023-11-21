import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";
import { isNil, redrawAll } from "@core/vim";

function generateActions() {
  return ActionGroupBuilder.start()
    .category("CloseBuffer")
    .addOpts({
      id: "close-buffer.delete-all-hidden-buffers",
      title: "Delete all non-visible buffers",
      callback: () => {
        luaRequire("close_buffers").delete({ type: "hidden", force: true });
        redrawAll();
      },
      keys: "<leader>ch",
    })
    .addOpts({
      id: "close-buffer.delete-all-buffers-without-name",
      title: "Delete all buffers without name",
      callback: () => {
        luaRequire("close_buffers").delete({ type: "nameless" });
        redrawAll();
      },
    })
    .addOpts({
      id: "close-buffer.delete-current-buffer",
      title: "Delete the current buffer",
      callback: () => {
        luaRequire("close_buffers").delete({ type: "this" });
        redrawAll();
      },
    })
    .addOpts({
      id: "close-buffer.delete-all-buffers-matching-the-regex",
      title: "Delete all buffers matching the regex",
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
    })
    .build();
}

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
};

export const plugin = new Plugin(andActions(spec, generateActions));
