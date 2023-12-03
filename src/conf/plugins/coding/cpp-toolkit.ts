import { ActionGroupBuilder, Plugin, fixPluginOpts } from "@core/model";

const spec = {
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
  allowInVscode: true,
  providedActions: () => {
    const actionsGroup = new ActionGroupBuilder()
      .from("cpp-toolkit")
      .category("CppToolkit")
      .condition((buf) => {
        return buf.filetype === "cpp" || buf.filetype === "c";
      })
      .addOpts({
        id: "cpptoolkit.insert-header",
        title: "Insert header",
        callback: "Telescope cpptoolkit insert_header",
      })
      .addOpts({
        id: "cpptoolkit.gen-def",
        title: "Generate function implementation",
        callback: "CppGenDef",
      })
      .addOpts({
        id: "cpptoolkit.move-value",
        title: "Move value",
        callback: "CppToolkit shortcut move_value",
      })
      .addOpts({
        id: "cpptoolkit.forward-value",
        title: "Forward value",
        callback: "CppToolkit shortcut forward_value",
      });
    return actionsGroup.build();
  },
};

export const plugin = new Plugin(fixPluginOpts(spec));
