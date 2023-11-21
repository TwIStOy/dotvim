import { Plugin, PluginOpts } from "@core/model";

const spec: PluginOpts = {
  shortUrl: "stevearc/aerial.nvim",
  lazy: {
    dependencies: [
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    ],
    cmd: [
      "AerialToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialClose",
      "AerialCloseAll",
      "AerialNext",
      "AerialPrev",
      "AerialGo",
      "AerialInfo",
      "AerialNavToggle",
      "AerialNavOpen",
      "AerialNavClose",
    ],
    opts: {
      backends: ["lsp", "markdown", "man"],
      layout: {
        default_direction: "right",
        placement: "edge",
        preserve_equality: true,
      },
      attach_mode: "global",
      filter_kind: false,
      post_parse_symbol: postParseSymbol,
      show_guides: true,
    },
    config: function (_, opts) {
      luaRequire("aerial").setup(opts);
      luaRequire("telescope").load_extension("aerial");
    },
  },
};

function postParseSymbol(_bufnr: number, item: any, ctx: any) {
  function mergeNestedNamespaces(item: any) {
    if (
      item.kind === "Namespace" &&
      (item.children as any[]).length == 1 &&
      item.children[1].kind == "Namespace" &&
      item.lnum == item.children[1].lnum &&
      item.end_lnum == item.children[1].end_lnum
    ) {
      item.name = `${item.name}::${item.children[1].name}`;
      item.children = item.children[1].children;
      for (let child of item.children as any[]) {
        child.parent = item;
        child.level = item.level + 1;
      }
      mergeNestedNamespaces(item);
    }
  }
  if (ctx.backend_name === "lsp" && ctx.lang === "clangd") {
    mergeNestedNamespaces(item);
  }
  return true;
}

export const plugin = new Plugin(spec);
