import { LspServer } from "@core/model";

export const server = new LspServer({
  name: "sourcekit",
  exe: false,
  setup: (
    _server: LspServer,
    on_attach: () => void,
    capabilities: LuaTable
  ) => {
    luaRequire("lspconfig").sourcekit.setup({
      // cmd: ["xcrun", "--toolchain", "swift", "sourcekit-lsp"],
      cmd: [
        "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
      ],
      filetypes: ["swift", "objective-c", "objective-cpp"],
      on_attach: on_attach,
      capabilities: capabilities,
    });
  },
});
