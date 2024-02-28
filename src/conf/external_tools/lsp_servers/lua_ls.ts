import { LspServer } from "@core/model";

// const enabledPlugins = [
//   "telescope.nvim",
//   "plenary.nvim",
//   "lazy.nvim",
//   "nui.nvim",
// ];

export const server = new LspServer({
  name: "lua_ls",
  exe: false,
  setup: (s: LspServer, on_attach, capabilities) => {
    let luaLibraries = [
      vim.fn.expand("$VIMRUNTIME/lua"),
      vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
      "${3rd}/luassert/library",
      `${vim.fn.stdpath("data")}/lazy/lazy.nvim/lua`,
      `${vim.fn.stdpath("data")}/lazy/plenary.nvim/lua`,
      `${vim.fn.stdpath("data")}/lazy/noice.nvim/lua`,
      `${vim.fn.stdpath("data")}/lazy/nui.nvim/lua`,
      `${vim.fn.stdpath("data")}/lazy/plenary.nvim/lua`,
    ];

    luaRequire("lspconfig").lua_ls.setup({
      on_attach: on_attach,
      capabilities: capabilities,
      settings: {
        Lua: {
          runtime: {
            version: "LuaJIT",
            // @ts-ignore
            path: vim.split(package.path, ";"),
          },
          diagnostics: {
            globals: ["vim"],
            disable: ["missing-fields"],
          },
          workspace: { library: luaLibraries },
          format: {
            enable: true,
            defaultConfig: {
              indent_style: "space",
              continuation_indent_size: "2",
            },
          },
        },
      },
    });
  },
});
