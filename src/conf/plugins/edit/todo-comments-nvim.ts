import { MenuBarPathPart } from "@core/components";
import { Plugin, PluginOpts } from "@core/model";

const navigateMenu: MenuBarPathPart[] = ["Navigate"];
const viewMenu: MenuBarPathPart[] = ["View"];

const spec: PluginOpts = {
  shortUrl: "TwIStOy/todo-comments.nvim",
  lazy: {
    event: "BufReadPost",
    cmd: ["TodoTrouble", "TodoTelescope"],
    opts: {
      highlight: { keyword: "wide_bg", pattern: "(KEYWORDS)([^)]*):" },
      search: { pattern: "(KEYWORDS)([^)]*):" },
      keywords: {
        HACK: { alt: ["UNSAFE"] },
      },
    },
    config: true,
  },
  extends: {
    commands: {
      category: "TodoComments",
      commands: [
        {
          name: "Open todos in trouble",
          callback: "TodoTrouble",
          keys: "<leader>xt",
          shortDesc: "trouble-todo",
          menuBar: {
            path: viewMenu,
          },
        },
        {
          name: "Open todos,fix,fixme in trouble",
          callback: "TodoTrouble keywords=TODO,FIX,FIXME",
          keys: "<leader>xT",
          shortDesc: "trouble-TFF",
          menuBar: {
            path: viewMenu,
          },
        },
        {
          name: "List all todos in telescope",
          callback: "TodoTelescope",
          keys: "<leader>lt",
          shortDesc: "list-todos",
          menuBar: {
            path: viewMenu,
          },
        },
        {
          name: "Goto next todo",
          callback: () => {
            luaRequire("todo-comments").just_next();
          },
          keys: "]t",
          shortDesc: "jump-next-todo",
          menuBar: {
            path: navigateMenu,
          },
        },
        {
          name: "Goto previous todo",
          callback: () => {
            luaRequire("todo-comments").just_prev();
          },
          keys: "[t",
          shortDesc: "jump-prev-todo",
          menuBar: {
            path: navigateMenu,
          },
        },
      ],
    },
  },
};

export const plugin = new Plugin(spec);
