import {
  ActionGroupBuilder,
  Plugin,
  PluginOptsBase,
  andActions,
} from "@core/model";

const spec: PluginOptsBase = {
  shortUrl: "crusj/bookmarks.nvim",
  lazy: {
    opts: {
      mappings_enabled: false,
      sign_icon: "",
      virt_pattern: [],
    },
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
    })
    .addOpts({
      id: "bookmarks.add-bookmark",
      title: "Add bookmark",
      callback: () => {
        luaRequire("bookmarks").add_bookmarks();
      },
    })
    .addOpts({
      id: "bookmarks.delete-at-virt-line",
      title: "Delete bookmark at virt text line",
      callback: () => {
        luaRequire("bookmarks.list").delete_on_virt();
      },
    })
    .addOpts({
      id: "bookmarks.show-bookmark-desc",
      title: "Show bookmark desc",
      callback: () => {
        luaRequire("bookmarks.list").show_desc();
      },
    })
    .build();
}

export const plugin = new Plugin(andActions(spec, generateActions));
