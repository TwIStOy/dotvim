import { ActionGroupBuilder, Plugin, PluginOpts } from "@core/model";

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
  allowInVscode: true,
  providedActions: () => {
    const actionsGroup = new ActionGroupBuilder()
      .from("cpp-toolkit")
      .category("CppToolkit");
    actionsGroup.addOpts({
      id: "cpptoolkit.insert-header",
      title: "Insert header",
      callback: "Telescope cpptoolkit insert_header",
    });
    actionsGroup.addOpts({
      id: "cpptoolkit.gen-def",
      title: "Generate function implementation",
      callback: "CppGenDef",
    });
    actionsGroup.addOpts({
      id: "cpptoolkit.move-value",
      title: "Move value",
      callback: "CppToolkit shortcut move_value",
    });
    actionsGroup.addOpts({
      id: "cpptoolkit.forward-value",
      title: "Forward value",
      callback: "CppToolkit shortcut forward_value",
    });
    return actionsGroup.build();
  },
};

export default new Plugin(spec);
