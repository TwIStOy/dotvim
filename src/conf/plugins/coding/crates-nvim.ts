import { ActionGroupBuilder, Plugin, PluginOpts } from "@core/model";

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
  allowInVscode: true,
  providedActions() {
    let group = new ActionGroupBuilder()
      .from("crates.nvim")
      .category("Crates")
      .condition((buf) => buf.fullFileName.endsWith("Cargo.toml"));
    group.addOpts({
      id: "crates-nvim.open-homepage",
      title: "Open homepage under cursor",
      callback: () => {
        luaRequire("crates").open_homepage();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-documentation",
      title: "Open documentation under cursor",
      callback: () => {
        luaRequire("crates").open_documentation();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-repository",
      title: "Open repository under cursor",
      callback: () => {
        luaRequire("crates").open_repository();
      },
    });
    group.addOpts({
      id: "crates-nvim.upgrade-crate",
      title: "Upgrade crate under cursor",
      callback: () => {
        luaRequire("crates").upgrade_crate();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-crate-popup",
      title: "Open crate popup",
      callback: () => {
        luaRequire("crates").show_crate_popup();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-versions-popup",
      title: "Open versions popup",
      callback: () => {
        luaRequire("crates").show_versions_popup();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-features-popup",
      title: "Open features popup",
      callback: () => {
        luaRequire("crates").show_features_popup();
      },
    });
    group.addOpts({
      id: "crates-nvim.open-dependencies-popup",
      title: "Open dependencies popup",
      callback: () => {
        luaRequire("crates").show_dependencies_popup();
      },
    });
    return group.build();
  },
};

export default new Plugin(spec);
