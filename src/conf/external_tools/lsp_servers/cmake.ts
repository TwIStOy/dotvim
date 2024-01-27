import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "cmake",
  exe: false,
  setup: (_: LspServer, on_attach, capabilities) => {
    luaRequire("lspconfig").cmake.setup({
      on_attach: on_attach,
      capabilities: capabilities,
      initializationOptions: { buildDirectory: "build" },
    });
  },
});
