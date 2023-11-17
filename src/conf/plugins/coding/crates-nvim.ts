import { RightClickIndexes } from "@conf/base";
import { Plugin, PluginOpts } from "@core/plugin";

const basePath = [{ title: "Crates", index: RightClickIndexes.crates }];

const spec: PluginOpts = {
  shortUrl: "saecki/crates.nvim",
  lazy: {
    lazy: true,
    dependencies: [
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "MunifTanjim/nui.nvim",
    ],
    event: {
      event: "BufRead",
      pattern: "Cargo.toml",
    },
    init: () => {
      // register event at very start of init
      vim.api.nvim_create_autocmd("BufRead", {
        group: vim.api.nvim_create_augroup("CmpSourceCargo", { clear: true }),
        pattern: "Cargo.toml",
        callback: () => {
          const cmp = luaRequire("cmp");
          cmp.setup.buffer({ sources: [{ name: "crates" }] });
        },
      });
    },
    config: () => {
      luaRequire("crates").setup({
        autoload: true,
        popup: { autofocus: true, border: "rounded" },
        null_ls: { enabled: true, name: "crates.nvim" },
      });

      // BufRead event is missing, because of lazy-loading
      luaRequire("crates").update();
    },
  },
  extends: {
    allowInVscode: true,
    commands: {
      enabled: (buf) => {
        return buf.fullFileName.endsWith("Cargo.toml");
      },
      commands: [
        {
          name: "Open homepage under cursor",
          callback: () => {
            luaRequire("crates").open_homepage();
          },
          rightClick: {
            title: "Open homepage",
            path: basePath,
          },
        },
        {
          name: "Open documentation under cursor",
          callback: () => {
            luaRequire("crates").open_documentation();
          },
          rightClick: {
            title: "Open documentation",
            path: basePath,
          },
        },
        {
          name: "Open repository under cursor",
          callback: () => {
            luaRequire("crates").open_repository();
          },
          rightClick: {
            title: "Open repository",
            path: basePath,
          },
        },
        {
          name: "Upgrade crate under cursor",
          callback: () => {
            luaRequire("crates").upgrade_crate();
          },
          rightClick: {
            title: "Upgrade crate",
            path: basePath,
          },
        },
        {
          name: "Open crate popup",
          callback: () => {
            luaRequire("crates").show_crate_popup();
          },
          rightClick: {
            title: "Crate",
            path: [...basePath, { title: "Popups", keys: ["p"] }],
            keys: ["c"],
          },
        },
        {
          name: "Open versions popup",
          callback: () => {
            luaRequire("crates").show_versions_popup();
          },
          rightClick: {
            title: "Versions",
            path: [...basePath, { title: "Popups", keys: ["p"] }],
            keys: ["v"],
          },
        },
        {
          name: "Open features popup",
          callback: () => {
            luaRequire("crates").show_features_popup();
          },
          rightClick: {
            title: "Features",
            path: [...basePath, { title: "Popups", keys: ["p"] }],
            keys: ["f"],
          },
        },
        {
          name: "Open dependencies popup",
          callback: () => {
            luaRequire("crates").show_dependencies_popup();
          },
          rightClick: {
            title: "Dependencies",
            path: [...basePath, { title: "Popups", keys: ["p"] }],
            keys: ["d"],
          },
        },
      ],
    },
  },
};

export default new Plugin(spec);
