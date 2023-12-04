import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "crusj/bookmarks.nvim",
  lazy: {
    dependencies: [
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    ],
    event: ["BufReadPost"],
    opts: {
      mappings_enabled: false,
      sign_icon: "",
      virt_pattern: [
        "*.dart",
        "*.cpp",
        "*.ts",
        "*.lua",
        "*.js",
        "*.c",
        "*.h",
        "*.cc",
        "*.hh",
        "*.hpp",
        "*.md",
        "*.rs",
        "*.toml",
      ],
      fix_enable: true,
    },
    config: (_, opts) => {
      luaRequire("bookmarks").setup(opts);
    },
    keys: [
      {
        [1]: "<leader>lm",
        [2]: () => {
          vim.api.nvim_command("Telescope bookmarks");
        },
        desc: "list-bookmarks",
        silent: true,
      },
    ],
  },
};

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Bookmarks")
    .from("bookmarks.nvim")
    .addOpts({
      id: "bookmarks.toggle-bookmarks",
      title: "Toggle bookmarks",
      callback: () => {
        luaRequire("bookmarks").toggle_bookmarks();
      },
      keys: [{ [1]: "<leader>bt", desc: "toggle-bookmarks", silent: true }],
    })
    .addOpts({
      id: "bookmarks.add-bookmark",
      title: "Add bookmark",
      callback: () => {
        luaRequire("bookmarks").add_bookmarks();
      },
      keys: [{ [1]: "<leader>ba", desc: "add-bookmark", silent: true }],
    })
    .addOpts({
      id: "bookmarks.delete-at-virt-line",
      title: "Delete bookmark at virt text line",
      callback: () => {
        luaRequire("bookmarks.list").delete_on_virt();
      },
      keys: [{ [1]: "<leader>bd", desc: "delete-at-virt-line", silent: true }],
    })
    .addOpts({
      id: "bookmarks.show-bookmark-desc",
      title: "Show bookmark desc",
      callback: () => {
        luaRequire("bookmarks.list").show_desc();
      },
      keys: [{ [1]: "<leader>bs", desc: "show-bookmark-desc", silent: true }],
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
