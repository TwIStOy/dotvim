import { LspServer } from "@core/ext_tool";

export default new LspServer({
  name: "typescript-tools",
  exe: false,
  setup(server: LspServer, on_attach: () => void, _capabilities: LuaTable) {
    luaRequire("typescript-tools").setup({
      on_attach: on_attach,
      settings: {
        tsserver_path: server.executable,
        tsserver_locale: "en",
        complete_function_calls: true,
      },
    });
  },
});
