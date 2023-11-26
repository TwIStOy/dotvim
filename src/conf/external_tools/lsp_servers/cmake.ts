import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "cmake",
  exe: {
    masonPkg: "cmake-language-server",
  },
  setup: (s: LspServer, on_attach, capabilities) => {
    luaRequire("lspconfig").cmake.setup({
      cmd: [s.executable],
      on_attach: on_attach,
      capabilities: capabilities,
      initializationOptions: { buildDirectory: "build" },
    });
  },
});
