import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";

function actions() {
  return ActionGroupBuilder.start()
    .category("TodoComments")
    .from("todo-comments.nvim")
    .addOpts({
      id: "todo-comments.open-todos-in-trouble",
      title: "Open todos in trouble",
      callback: "TodoTrouble",
      keys: "<leader>xt",
      description: "trouble-todo",
    })
    .addOpts({
      id: "todo-comments.open-todos-fix-fixme-in-trouble",
      title: "Open todos,fix,fixme in trouble",
      callback: "TodoTrouble keywords=TODO,FIX,FIXME",
      keys: "<leader>xT",
      description: "trouble-TFF",
    })
    .addOpts({
      id: "todo-comments.list-all-todos-in-telescope",
      title: "List all todos in telescope",
      callback: "TodoTelescope",
      keys: "<leader>lt",
      description: "list-todos",
    })
    .addOpts({
      id: "todo-comments.goto-next-todo",
      title: "Goto next todo",
      callback: () => {
        luaRequire("todo-comments").jump_next();
      },
      keys: "]t",
      description: "jump-next-todo",
    })
    .addOpts({
      id: "todo-comments.goto-previous-todo",
      title: "Goto previous todo",
      callback: () => {
        luaRequire("todo-comments").jump_prev();
      },
      keys: "[t",
      description: "jump-prev-todo",
    })
    .build();
}

const spec: PluginOpts = {
  shortUrl: "TwIStOy/todo-comments.nvim",
  lazy: {
    event: "BufReadPost",
    cmd: ["TodoTrouble", "TodoTelescope"],
    dependencies: ["nvim-lua/plenary.nvim"],
    opts: {
      highlight: { keyword: "wide_bg", pattern: "(KEYWORDS)\\([^)]*\\):" },
      search: { pattern: "(KEYWORDS)\\([^)]*\\):" },
      keywords: {
        HACK: { alt: ["UNSAFE"] },
        FIX: { alt: ["FIXME", "BUG", "FIXIT", "ISSUE", "FUCKING"] },
      },
    },
    config: (_, opts) => {
      luaRequire("todo-comments").setup(opts);
    },
  },
};

export const plugin = new Plugin(andActions(spec, actions));
