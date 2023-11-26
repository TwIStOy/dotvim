import { LspServer } from "@core/model";
import { HttsContext } from "context";

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
  exe: {
    masonPkg: "clangd",
  },
  setup(_server: LspServer, on_attach: () => void, capabilities: LuaTable) {
    luaRequire("lspconfig").clangd.setup({
      cmd: [
        `${HttsContext.getInstance().masonBinRoot}/clangd`,
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
