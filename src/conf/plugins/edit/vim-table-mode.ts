import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "dhruvasagar/vim-table-mode",
  lazy: {
    lazy: true,
    ft: ["markdown"],
    cmd: ["TableModeEnable", "TableModeDisable"],
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .from("vim-table-mode")
    .category("Table Mode")
    .condition((buf) => {
      return buf.filetype === "markdown";
    })
    .addOpts({
      id: "vim-table-mode.enable",
      title: "Enable table mode",
      callback: () => {
        vim.api.nvim_command("TableModeEnable");
      },
    })
    .addOpts({
      id: "vim-table-mode.disable",
      title: "Disable table mode",
      callback: () => {
        vim.api.nvim_command("TableModeDisable");
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
