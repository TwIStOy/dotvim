import { Plugin, PluginOptsBase } from "@core/model";

function addSnippets(ft: string, snippets: (LuaTable | (() => LuaTable))[]) {
  let ls = luaRequire("luasnip");
  let ret = snippets.map((s) => {
    if (typeof s === "function") {
      return s();
    }
    return s;
  });

  ls.add_snippets(ft, ret);
}

function addMappedSnippets(snippets: {
  [ft: string]: (LuaTable | (() => LuaTable))[];
}) {
  for (let ft in snippets) {
    addSnippets(ft, snippets[ft]);
  }
}

const spec: PluginOptsBase = {
  shortUrl: "TwIStOy/LuaSnip",
  lazy: {
    build: "make install_jsregexp",
    dev: true,
    event: ["InsertEnter"],
    config: () => {
      let ls = luaRequire("luasnip");
      let ft_functions = luaRequire("luasnip.extras.filetype_functions");

      ls.config.setup({
        enable_autosnippets: true,
        history: false,
        updateevents: "TextChanged,TextChangedI",
        region_check_events: ["CursorMoved", "CursorMovedI", "CursorHold"],
        ft_func: ft_functions.from_pos_or_filetype,
        store_selection_keys: "<C-/>",
      });

      addSnippets("all", luaRequire("ht.snippets.all")());
      addSnippets("cpp", luaRequire("ht.snippets.cpp")());
      addSnippets("rust", luaRequire("ht.snippets.rust")());
      addSnippets("lua", luaRequire("ht.snippets.lua")());
      addSnippets("dart", luaRequire("ht.snippets.dart")());
      addMappedSnippets(luaRequire("ht.snippets.markdown")());
    },
    keys: [
      {
        [1]: "<C-e>",
        [2]: () => {
          let ls = luaRequire("luasnip");
          if (ls.choice_active()) {
            ls.change_choice(1);
          }
        },
        mode: ["i", "s", "n", "v"],
      },
      {
        [1]: "<C-b>",
        [2]: () => {
          let ls = luaRequire("luasnip");
          if (ls.jumpable(-1)) {
            ls.jumpable(-1);
          }
        },
        mode: ["i", "s", "n", "v"],
      },
      {
        [1]: "<C-f>",
        [2]: () => {
          let ls = luaRequire("luasnip");
          if (ls.expand_or_jumpable()) {
            ls.expand_or_jump();
          }
        },
        mode: ["i", "s", "n", "v"],
      },
    ],
  },
  allowInVscode: true,
};

export const plugin = new Plugin(spec);
