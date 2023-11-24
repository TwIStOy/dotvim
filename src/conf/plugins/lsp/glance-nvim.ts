import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "dnlhc/glance.nvim",
  lazy: {
    lazy: true,
    cmd: ["Glance"],
    config: () => {
      let glance = luaRequire("glance");
      let actions = glance.actions;

      glance.setup({
        detached: (winid: number) => {
          return vim.api.nvim_win_get_width(winid) < 100;
        },
        preview_win_opts: { cursorline: true, number: true, wrap: false },
        border: { disable: true, top_char: "―", bottom_char: "―" },
        theme: { enable: true },
        list: { width: 0.2 },
        mappings: {
          list: {
            ["j"]: actions.next,
            ["k"]: actions.previous,
            ["<Down>"]: false,
            ["<Up>"]: false,
            ["<Tab>"]: actions.next_location,
            ["<S-Tab>"]: actions.previous_location,
            ["<C-u>"]: actions.preview_scroll_win(5),
            ["<C-d>"]: actions.preview_scroll_win(-5),
            ["v"]: false,
            ["s"]: false,
            ["t"]: false,
            ["<CR>"]: actions.jump,
            ["o"]: false,
            ["<leader>l"]: false,
            ["q"]: actions.close,
            ["Q"]: actions.close,
            ["<Esc>"]: actions.close,
          },
          preview: {
            ["Q"]: actions.close,
            ["<Tab>"]: false,
            ["<S-Tab>"]: false,
            ["<leader>l"]: false,
          },
        },
        folds: { fold_closed: "󰅂", fold_open: "󰅀", folded: false },
        indent_lines: { enable: false },
        winbar: { enable: true },
        hooks: {
          before_open: (
            results: any[],
            open: any,
            jump: any,
            method: string
          ) => {
            if (method === "references" || method === "implementations") {
              open(results);
            } else if (results.length === 1) {
              jump(results[0]);
            } else {
              open(results);
            }
          },
        },
      });
    },
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("LSP")
    .from("glance.nvim")
    .condition((buf) => {
      return buf.lspServers.length > 0;
    })
    .addOpts({
      id: "glance.goto-definition",
      title: "Goto definition",
      callback: () => {
        luaRequire("glance").open("definitions");
      },
    })
    .addOpts({
      id: "glance.goto-implementation",
      title: "Goto implementation",
      callback: () => {
        luaRequire("glance").open("implementations");
      },
    })
    .addOpts({
      id: "glance.goto-type-definition",
      title: "Goto type definition",
      callback: () => {
        luaRequire("glance").open("type_definitions");
      },
    })
    .addOpts({
      id: "glance.goto-reference",
      title: "Goto reference",
      callback: () => {
        luaRequire("glance").open("references");
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
