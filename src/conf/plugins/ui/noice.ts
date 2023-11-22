import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

function generateActions() {
  return ActionGroupBuilder.start()
    .from("noice.nvim")
    .category("Noice")
    .addOpts({
      id: "noice.show-message-history",
      callback: "Noice history",
      title: "Shows the message history",
    })
    .addOpts({
      id: "noice.show-last-message",
      callback: "Noice last",
      title: "Shows the last message in a popup",
    })
    .addOpts({
      id: "noice.dismiss-all-messages",
      callback: "Noice dismiss",
      title: "Dismiss all visible messages",
    })
    .addOpts({
      id: "noice.disable",
      callback: "Noice disable",
      title: "Disables Noice",
    })
    .addOpts({
      id: "noice.enable",
      callback: "Noice enable",
      title: "Enables Noice",
    })
    .addOpts({
      id: "noice.show-stats",
      callback: "Noice stats",
      title: "Show debugging stats",
    })
    .addOpts({
      id: "noice.show-message-history-in-telescope",
      callback: "Noice telescope",
      title: "Opens message history in Telescope",
    })
    .addOpts({
      id: "noice.show-errors",
      callback: "Noice errors",
      title: "Shows the error messages in a split",
    })
    .build();
}

const spec: PluginOpts = {
  shortUrl: "folke/noice.nvim",
  lazy: {
    event: ["ModeChanged", "BufReadPre", "InsertEnter"],
    dependencies: ["MunifTanjim/nui.nvim", "rcarriga/nvim-notify"],
    opts: {
      lsp: {
        progress: { enabled: false, throttle: 1000 / 10 },
        override: {
          ["vim.lsp.util.convert_input_to_markdown_lines"]: true,
          ["vim.lsp.util.stylize_markdown"]: true,
          ["cmp.entry.get_documentation"]: true,
        },
        signature: {
          enabled: false,
          auto_open: {
            enabled: true,
            trigger: true,
            luasnip: true,
            throttle: 50,
          },
        },
      },
      messages: { enabled: false },
      presets: {
        bottom_search: false,
        command_palette: true,
        long_message_to_split: true,
        inc_rename: false,
        lsp_doc_border: true,
      },
    },
    config: true,
  },
};

export const plugin = new Plugin(andActions(spec, generateActions));
