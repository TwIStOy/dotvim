import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "gopls",
  exe: false,
  setup: (
    _server: LspServer,
    on_attach: () => void,
    capabilities: LuaTable
  ) => {
    luaRequire("lspconfig").gopls.setup({
      on_attach,
      capabilities,
    });
  },
});
