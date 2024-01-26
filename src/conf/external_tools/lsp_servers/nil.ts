import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "nil",
  exe: false,
  setup: (
    _server: LspServer,
    on_attach: () => void,
    capabilities: LuaTable
  ) => {
    luaRequire("lspconfig").nil_ls.setup({
      cmd: ["nil"],
      on_attach,
      capabilities,
      settings: {
        nil: {
          formatting: {
            command: ["nixpkgs-fmt"],
          },
          flake: {
            autoArchive: true,
            autoEvalInputs: true,
          },
        },
      },
    });
  },
});
