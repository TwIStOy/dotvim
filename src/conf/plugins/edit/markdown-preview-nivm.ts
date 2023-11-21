import { Plugin, PluginOpts, buildSimpleCommand } from "@core/model";

const spec: PluginOpts<[]> = {
  shortUrl: "iamcco/markdown-preview.nvim",
  lazy: {
    ft: ["markdown"],
    build: () => {
      vim.api.nvim_command("call mkdp#util#install()");
    },
    init: () => {
      vim.g.mkdp_open_to_the_world = true;
      vim.g.mkdp_echo_preview_url = true;
    },
  },
  extends: {
    commands: {
      category: "MdPreview",
      commands: [
        buildSimpleCommand("Start md preview", "MarkdownPreview"),
        buildSimpleCommand("Stop md preview", "MarkdownPreviewStop"),
        buildSimpleCommand("Toggle md preview", "MarkdownPreviewToggle"),
      ],
    },
  },
};

export default new Plugin(spec);
