import { Plugin, PluginOpts } from "../../../core/plugin";
import formatters from "../../external_tools/formatters";

const spec: PluginOpts = {
  shortUrl: "williamboman/mason.nvim",
  lazy: {
    opts: {
      PATH: "skip",
    },
    cmd: [
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    ],
    event: ["VeryLazy"],
    config(_, opts) {
      vim.defer_fn(() => config(_, opts), 100);
    },
  },
};

async function config(_: any, opts: AnyNotNil) {
  luaRequire("mason").setup(opts);

  let registry = luaRequire("mason-registry");

  let check_new_version_promises: Promise<{
    name: string;
    has_new_version: boolean;
  }>[] = [];

  for (let fmt of formatters) {
    let spec = fmt.asMasonSpec();
    if (!spec) continue;

    let pkg = registry.get_package(spec.name);
    if (!pkg.is_installed()) {
      vim.notify(`Installing ${spec.name}...`);
      let handle = pkg.install(spec);
      handle.once(
        "closed",
        vim.schedule_wrap(() => {
          if (pkg.is_installed()) {
            vim.notify(`${spec!.name} was succesfully installed!`);
          } else {
            vim.notify(`Failed to install ${spec!.name}`, vim.log.levels.ERROR);
          }
        })
      );
    } else {
      let promise = new Promise<{
        name: string;
        has_new_version: boolean;
      }>((resolve) => {
        pkg.check_new_version((result: boolean) => {
          resolve({
            name: spec!.name,
            has_new_version: result,
          });
        });
      });
      check_new_version_promises.push(promise);
    }
  }

  if (check_new_version_promises.length > 0) {
    let results = await Promise.all(check_new_version_promises);
    let should_be_updated = results.filter((r) => r.has_new_version);
    if (should_be_updated.length == 0) {
      vim.notify(`All tools are up to date!`, vim.log.levels.INFO, {
        title: "Mason",
      });
    } else {
      let names = should_be_updated.map((r) => r.name).join(", ");
      vim.notify(
        `The following tools should be updated: ${names}`,
        vim.log.levels.WARN,
        {
          title: "Mason",
        }
      );
    }
  }
}

export default new Plugin(spec);
