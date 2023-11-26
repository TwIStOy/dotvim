import { LspServer } from "@core/model";
import { HttsContext } from "context";

export const server = new LspServer({
  name: "pyright",
  exe: {
    masonPkg: "pyright",
  },
  setup: (_server: LspServer, on_attach, capabilities) => {
    luaRequire("lspconfig").pyright.setup({
      cmd: [`${HttsContext.getInstance()}/pyright-langserver`, "--stdio"],
      on_attach: on_attach,
      capabilities: capabilities,
    });
  },
});
