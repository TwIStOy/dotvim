import { AllMaybeMasonPackage } from "@conf/external_tools";
import {
  ActionGroupBuilder,
  Plugin,
  PluginOpts,
  andActions,
} from "@core/model";
import { inputArgsAndExec } from "@core/vim";

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

function generateActions() {
  return ActionGroupBuilder.start()
    .category("Mason")
    .from("mason.nvim")
    .addOpts({
      id: "mason.open-window",
      title: "Open mason window",
      callback: "Mason",
    })
    .addOpts({
      id: "mason.install",
      title: "Install a tool",
      callback: inputArgsAndExec("MasonInstall"),
    })
    .addOpts({
      id: "mason.update",
      title: "Update a tool",
      callback: "MasonUpdate",
      description: "Update a tool",
    })
    .addOpts({
      id: "mason.uninstall",
      title: "Uninstall a tool",
      callback: inputArgsAndExec("MasonUninstall"),
      description: "Uninstall a tool",
    })
    .addOpts({
      id: "mason.uninstall-all",
      title: "Uninstall all tools",
      callback: "MasonUninstallAll",
    })
    .addOpts({
      id: "mason.show-log",
      title: "Show mason log",
      callback: "MasonLog",
    })
    .build();
}

interface VersionCheckResult {
  name: string;
  outdated: boolean;
}

function registryUpdate(): Promise<void> {
  return new Promise((resolve) => {
    let registry = luaRequire("mason-registry");
    registry.update(() => {
      resolve();
    });
  });
}

function checkPackage(pkg: any, name: string): Promise<VersionCheckResult> {
  return new Promise((resolve) => {
    pkg.check_new_version((result: boolean) => {
      resolve({
        name: name,
        outdated: result,
      });
    });
  });
}

function installPackage(pkg: any, name: string): Promise<void> {
  return new Promise((resolve) => {
    vim.notify(`Installing ${name}...`);
    let handle = pkg.install(spec);
    handle.once(
      "closed",
      vim.schedule_wrap(() => {
        if (pkg.is_installed()) {
          vim.notify(
            `"${name}" was succesfully installed!`,
            vim.log.levels.INFO,
            {
              title: "Mason",
            }
          );
        } else {
          vim.notify(`Failed to install ${name}`, vim.log.levels.ERROR, {
            title: "Mason",
          });
        }
        resolve();
      })
    );
  });
}

async function installAndUpgradePackages() {
  let registry = luaRequire("mason-registry");

  let upgradePackages: Promise<VersionCheckResult>[] = [];
  let promises: Promise<void>[] = [];

  for (let fmt of AllMaybeMasonPackage) {
    let spec = fmt.asMasonSpec();
    if (!spec) continue;

    let pkg = registry.get_package(spec.name);
    if (!pkg.is_installed()) {
      promises.push(installPackage(pkg, spec.name));
    } else {
      upgradePackages.push(checkPackage(pkg, spec.name));
    }
  }

  if (upgradePackages.length > 0) {
    await registryUpdate().then(() => {
      vim.notify("Registry updated!", vim.log.levels.INFO, {
        title: "Mason",
        render: "compact",
      });
    });
    promises.push(
      Promise.all(upgradePackages).then((results) => {
        let outdatedPackages = results.filter((r) => r.outdated);
        if (outdatedPackages.length === 0) {
          vim.notify(`All tools are up to date!`, vim.log.levels.INFO, {
            title: "Mason",
            render: "compact",
          });
        } else {
          let names = outdatedPackages.map((r) => r.name).join("\n  ");
          vim.notify(
            `The following tools should be updated:\n  ${names}`,
            vim.log.levels.WARN,
            {
              title: "Mason",
            }
          );
        }
      })
    );
  }

  await Promise.all(promises);
}

async function config(_: any, opts: AnyNotNil) {
  luaRequire("mason").setup(opts);
  installAndUpgradePackages();
}

export const plugin = new Plugin(andActions(spec, generateActions));
