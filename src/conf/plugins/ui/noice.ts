import { Plugin, PluginOpts } from "@core/plugin";
import { buildSimpleCommand } from "@core/types";

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
  extends: {
    allowInVscode: false,
    commands: [
      buildSimpleCommand("Shows the message history", "Noice history"),
      buildSimpleCommand("Shows the last message in a popup", "Noice last"),
      buildSimpleCommand("Dismiss all visible messages", "Noice dismiss"),
      buildSimpleCommand("Disables Noice", "Noice disable"),
      buildSimpleCommand("Enables Noice", "Noice enable"),
      buildSimpleCommand("Show debugging stats", "Noice stats"),
      buildSimpleCommand(
        "Opens message history in Telescope",
        "Noice telescope"
      ),
      buildSimpleCommand("Shows the error messages in a split", "Noice errors"),
    ],
  },
};

export default new Plugin(spec);
