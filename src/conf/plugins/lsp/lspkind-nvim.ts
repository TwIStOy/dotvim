import { Plugin, PluginOptsBase } from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "onsails/lspkind.nvim",
  lazy: {
    lazy: true,
    dependencies: ["nvim-tree/nvim-web-devicons"],
    config: () => {
      luaRequire("lspkind").init({
        mode: "symbol_text",
        symbol_map: {
          Array: "",
          Boolean: "",
          Class: "",
          Color: "",
          Constant: "",
          Constructor: "",
          Enum: "",
          EnumMember: "",
          Event: "",
          Field: "",
          File: "",
          Folder: "",
          Function: "",
          Interface: "",
          Key: "",
          Keyword: "",
          Method: "",
          Module: "",
          Namespace: "",
          Null: "",
          Number: "",
          Object: "",
          Operator: "",
          Package: "",
          Property: "",
          Reference: "",
          Snippet: "",
          String: "",
          Struct: "",
          Text: "",
          TypeParameter: "",
          Unit: "",
          Value: "",
          Variable: "",
          Copilot: "",
          Codeium: "",
          Math: "󰀫",
        },
      });
    },
  },
};

export const plugin = new Plugin(spec);
