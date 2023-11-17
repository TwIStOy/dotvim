import { Plugin, PluginOpts } from "@core/plugin";

const spec: PluginOpts = {
  shortUrl: "TwIStOy/cpp-toolkit.nvim",
  lazy: {
    dependencies: ["nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"],
    cmd: ["CppGenDef", "CppDebugPrint", "CppToolkit"],
    ft: ["cpp", "c"],
    config: () => {
      luaRequire("cpp-toolkit").setup({
        impl_return_type_style: "trailing",
      });
      luaRequire("telescope").load_extension("cpptoolkit");
    },
  },
  extends: {
    allowInVscode: true,
    commands: {
      enabled: (buf) => {
        return ["cpp", "c"].includes(buf.filetype);
      },
      rightClick: {
        path: [{ title: "CppToolkit", index: 41 }],
      },
      commands: [
        {
          name: "Fuzzy find header and insert",
          callback: () => {
            vim.api.nvim_command("Telescope cpptoolkit insert_header");
          },
          rightClick: {
            title: "Fuzzy insert header",
          },
        },
        {
          name: "Generate function implementation",
          callback: () => {
            vim.api.nvim_command("CppGenDef");
          },
          rightClick: {
            title: "Gen &impl",
          },
        },
        {
          name: "Move value",
          callback: () => {
            vim.api.nvim_command("CppToolkit shortcut move_value");
          },
          rightClick: {
            title: "Move value",
            keys: ["m"],
          },
        },
        {
          name: "Forward value",
          callback: () => {
            vim.api.nvim_command("CppToolkit shortcut forward_value");
          },
          rightClick: {
            title: "Move value",
            keys: ["f"],
          },
        },
      ],
    },
  },
};

export default new Plugin(spec);
