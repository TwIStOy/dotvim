import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "zbirenbaum/copilot.lua",
  lazy: {
    event: ["InsertEnter"],
    dependencies: ["nvim-lua/plenary.nvim"],
    opts: {
      suggestion: {
        auto_trigger: true,
        keymap: {
          accept: "<C-l>",
        },
      },
    },
    config: (_, opts) => {
      vim.defer_fn(() => {
        vim.system(["fish", "-c", "which node"], { text: true }, (comp) => {
          if (comp.code === 0) {
            const [nodePath, ..._args] = string.match(
              comp.stdout!,
              "^%s*(.-)%s*$"
            );
            opts.copilot_node_command = nodePath;
          }
          vim.schedule(() => {
            luaRequire("copilot").setup(opts);
          });
        });
      }, 100);
    },
  },
  extends: {
    commands: {
      category: "Copilot",
      commands: [
        {
          name: "Copilot status",
          description: "Show the status of Copilot",
          callback: () => {
            vim.api.nvim_command("Copilot status");
          },
        },
        {
          name: "Copilot auth",
          callback: () => {
            vim.api.nvim_command("Copilot auth");
          },
        },
        {
          name: "Copilot panel",
          callback: () => {
            vim.api.nvim_command("Copilot panel");
          },
        },
      ],
    },
  },
};

function actions() {
  return new ActionGroupBuilder()
    .from("copilot.lua")
    .category("Copilot")
    .addOpts({
      id: "copilot.status",
      title: "Copilot status",
      description: "Show the status of Copilot",
      callback: () => {
        vim.api.nvim_command("Copilot status");
      },
    })
    .addOpts({
      id: "copilot.auth",
      title: "Copilot auth",
      callback: () => {
        vim.api.nvim_command("Copilot auth");
      },
    })
    .addOpts({
      id: "copilot.show-panel",
      title: "Copilot panel",
      callback: () => {
        vim.api.nvim_command("Copilot panel");
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, actions));
