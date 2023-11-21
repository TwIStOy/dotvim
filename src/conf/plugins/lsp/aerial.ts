import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Aerial")
    .from("aerial.nvim")
    .condition((buf) => {
      return buf.lspServers.length > 0;
    })
    .addOpts({
      id: "aerial.toggle",
      title: "Toggle aerial window",
      callback: "AerialToggle",
    })
    .addOpts({
      id: "aerial.open",
      title: "Open aerial window",
      callback: "AerialOpen",
    })
    .addOpts({
      id: "aerial.open-all",
      title: "Open aerial for each visible window",
      callback: "AerialOpenAll",
    })
    .addOpts({
      id: "aerial.close",
      title: "Close aerial window",
      callback: "AerialClose",
    })
    .addOpts({
      id: "aerial.close-all",
      title: "Close all aerial windows",
      callback: "AerialCloseAll",
    })
    .addOpts({
      id: "aerial.info",
      title: "Print out info related to aerial",
      callback: "AerialInfo",
    })
    .addOpts({
      id: "aerial.nav-toggle",
      title: "Toggle nav window",
      callback: "AerialNavToggle",
    })
    .addOpts({
      id: "aerial.nav-open",
      title: "Open nav window",
      callback: "AerialNavOpen",
    })
    .addOpts({
      id: "aerial.nav-close",
      title: "Close nav window",
      callback: "AerialNavClose",
    })
    .build();
}

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

export const plugin = new Plugin(andActions(spec, generateActions));
