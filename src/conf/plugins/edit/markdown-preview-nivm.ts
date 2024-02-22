import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "iamcco/markdown-preview.nvim",
  nixPath: "markdown-preview-nvim",
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
};

function actions() {
  return new ActionGroupBuilder()
    .from("markdown-preview.nvim")
    .category("MdPreview")
    .condition((buf) => {
      return buf.filetype === "markdown";
    })
    .addOpts({
      id: "markdown-preview.start",
      title: "Start md preview",
      callback: () => {
        vim.api.nvim_command("MarkdownPreview");
      },
    })
    .addOpts({
      id: "markdown-preview.stop",
      title: "Stop md preview",
      callback: () => {
        vim.api.nvim_command("MarkdownPreviewStop");
      },
    })
    .addOpts({
      id: "markdown-preview.toggle",
      title: "Toggle md preview",
      callback: () => {
        vim.api.nvim_command("MarkdownPreviewToggle");
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, actions));
