import { AllLspServers } from "@conf/external_tools";
import { plugin as WhichKey } from "./which-key";
import { plugin as StartupTime } from "./vim-startuptime";
import { plugins as editPlugins } from "./edit";
import { plugins as lspPlugins } from "./lsp";
import { plugins as uiPlugins } from "./ui";
import { plugins as otherPlugins } from "./other";
import { plugins as codingPlugins } from "./coding";
import { plugins as treesitterPlugins } from "./treesitter";
import { plugins as libPlugins } from "./lib";
import { Action } from "@core/model";
import { builtinActions } from "@conf/actions/builtin";

export const AllPlugins = [
  WhichKey,
  StartupTime,
  editPlugins,
  lspPlugins,
  uiPlugins,
  otherPlugins,
  codingPlugins,
  treesitterPlugins,
  libPlugins,
] as const;

export const LazySpecs = [...AllPlugins, ...AllLspServers]
  .flat()
  .map((p) => p.asLazySpec());

export class ActionRegistry {
  private static instance?: ActionRegistry;

  private _actions: Map<string, Action<any>> = new Map();

  private constructor() {
    AllPlugins.flat().forEach((plug) => {
      plug.actions.forEach((action) => {
        this.add(action);
      });
    });
    builtinActions.forEach((action) => {
      this.add(action);
    });
  }

  static getInstance() {
    if (!ActionRegistry.instance) {
      ActionRegistry.instance = new ActionRegistry();
    }
    return ActionRegistry.instance;
  }

  private add(action: Action<any>) {
    if (this._actions.has(action.id)) {
      vim.notify(`Action ${action.id} already exists`, vim.log.levels.ERROR);
      return;
    }
    this._actions.set(action.id, action);
  }

  public get(id: string) {
    return this._actions.get(id);
  }

  public get actions() {
    return this._actions.values();
  }
}
