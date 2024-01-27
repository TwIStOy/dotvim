import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "pyright",
  exe: false,
  setup: (_server: LspServer, on_attach, capabilities) => {
    luaRequire("lspconfig").pyright.setup({
      cmd: ["pyright-langserver", "--stdio"],
      on_attach,
      capabilities,
    });
  },
});
