import { LspServer } from "@core/model";

export default new LspServer({
  name: "typescript-tools",
  exe: {
    masonPkg: "typescript-language-server",
  },
  setup(_server: LspServer, on_attach: () => void, _capabilities: LuaTable) {
    luaRequire("typescript-tools").setup({
      on_attach: on_attach,
      settings: {
        tsserver_locale: "en",
        complete_function_calls: true,
      },
    });
  },
});
