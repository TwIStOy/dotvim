import { Plugin, PluginOpts } from "../../../core/plugin";

const [nodePath, ..._args] = string.match(
  vim.system(["fish", "-c", "which node"], { text: true }).wait().stdout!,
  "^%s*(.-)%s*$"
);

const spec: PluginOpts = {
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
      copilot_node_command: nodePath,
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

export default new Plugin(spec);
