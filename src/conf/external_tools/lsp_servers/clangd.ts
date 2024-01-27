import {
  ActionGroupBuilder,
  LspServer,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";
import { HttsContext } from "context";

const spec: PluginOptsBase = {
  shortUrl: "p00f/clangd_extensions.nvim",
  lazy: {
    lazy: true,
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Clangd")
    .from("clangd_extensions.nvim")
    .condition((buf) => {
      for (let server of buf.lspServers) {
        if (server.name === "clangd") {
          return true;
        }
      }
      return false;
    })
    .addOpts({
      id: "clangd.switch-source-header",
      title: "Switch between source and header files",
      callback: "ClangdSwitchSourceHeader",
    })
    .addOpts({
      id: "clangd.view-ast",
      title: "View AST",
      callback: "ClangdAST",
    })
    .addOpts({
      id: "clangd.view-type-hierarchy",
      title: "View type hierarchy",
      callback: "ClangdTypeHierarchy",
    })
    .addOpts({
      id: "clangd.symbol-info",
      title: "Symbol info",
      callback: "ClangdSymbolInfo",
    })
    .addOpts({
      id: "clangd.memory-usage",
      title: "Memory usage",
      callback: "ClangdMemoryUsage",
    })
    .build();
}

const plugin = new Plugin(andActions(spec, generateActions));

function wrapOnAttach(defaultCallback: (client: any, bufnr: number) => void) {
  return (client: unknown, bufnr: number) => {
    defaultCallback(client, bufnr);

    vim.keymap.set(
      "n",
      "<leader>fa",
      () => {
        vim.api.nvim_command("ClangdSwitchSourceHeader");
      },
      {
        desc: "clangd-switch-header",
        buffer: bufnr,
      }
    );
  };
}

export const server = new LspServer({
  name: "clangd",
  plugin,
  exe: false,
  setup(_server: LspServer, on_attach: () => void, capabilities: LuaTable) {
    luaRequire("lspconfig").clangd.setup({
      cmd: [
        "clangd",
        "--clang-tidy",
        "--background-index",
        "--background-index-priority=normal",
        "--ranking-model=decision_forest",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--limit-references=100",
        "--limit-results=100",
        "--include-cleaner-stdlib",
        "-j=20",
      ],
      on_attach: wrapOnAttach(on_attach),
      capabilities: capabilities,
      filetypes: ["c", "cpp"],
    });

    luaRequire("clangd_extensions").setup({
      extensions: {
        autoSetHints: false,
        hover_with_actions: true,
        inlay_hints: {
          inline: false,
          only_current_line: false,
          only_current_line_autocmd: "CursorHold",
          show_parameter_hints: false,
          show_variable_name: true,
          other_hints_prefix: "",
          max_len_align: false,
          max_len_align_padding: 1,
          right_align: false,
          right_align_padding: 7,
          highlight: "Comment",
        },
        ast: {
          role_icons: {
            type: "🄣",
            declaration: "🄓",
            expression: "🄔",
            statement: ";",
            specifier: "🄢",
            ["template argument"]: "🆃",
          },
          kind_icons: {
            Compound: "🄲",
            Recovery: "🅁",
            TranslationUnit: "🅄",
            PackExpansion: "🄿",
            TemplateTypeParm: "🅃",
            TemplateTemplateParm: "🅃",
            TemplateParamObject: "🅃",
          },
        },
        memory_usage: { border: "rounded" },
        symbol_info: { border: "rounded" },
      },
    });
  },
});
