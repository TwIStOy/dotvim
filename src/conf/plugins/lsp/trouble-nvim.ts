import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
  removeReadonly,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "folke/trouble.nvim",
  lazy: {
    dependencies: ["folke/lsp-colors.nvim"],
    lazy: true,
    cmd: ["Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh"],
  },
};

function generateActions() {
  const lspActions = ActionGroupBuilder.start()
    .category("Trouble")
    .from("trouble.nvim")
    .condition((buf) => {
      return buf.lspServers.length > 0;
    })
    .addOpts({
      id: "trouble.open-workspace-diagnostic",
      title: "Open workspace diagnostic (Trouble)",
      callback: "Trouble workspace_diagnostic",
      keys: {
        [1]: "<leader>xw",
        desc: "lsp-workspace-diagnostic",
      },
    })
    .addOpts({
      id: "trouble.open-document-diagnostic",
      title: "Open document diagnostic (Trouble)",
      callback: "Trouble document_diagnostic",
      keys: {
        [1]: "<leader>xd",
        desc: "lsp-document-diagnostic",
      },
    })
    .build();
  const commonActions = ActionGroupBuilder.start()
    .category("Trouble")
    .from("trouble.nvim")
    .addOpts({
      id: "trouble.toggle-indow",
      title: "Toggle trouble window",
      callback: "TroubleToggle",
      keys: {
        [1]: "<leader>xx",
        desc: "trouble-toggle",
      },
    })
    .build();
  const actionsInTroubleWindow = ActionGroupBuilder.start()
    .category("Trouble")
    .from("trouble.nvim")
    .condition(() => {
      return luaRequire("trouble").is_open();
    })
    .addOpts({
      id: "trouble.previous-trouble",
      title: "Previous trouble item",
      callback: () => {
        luaRequire("trouble").previous({ skip_groups: true, jump: true });
      },
      keys: {
        [1]: "[q]",
        desc: "previous-trouble",
      },
    })
    .addOpts({
      id: "trouble.next-trouble",
      title: "Next trouble item",
      callback: () => {
        luaRequire("trouble").next({ skip_groups: true, jump: true });
      },
      keys: {
        [1]: "]q]",
        desc: "next-trouble",
      },
    })
    .build();
  return removeReadonly([
    ...lspActions,
    ...commonActions,
    ...actionsInTroubleWindow,
  ] as const);
}

export const plugin = new Plugin(andActions(spec, generateActions));
