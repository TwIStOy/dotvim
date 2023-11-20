import { LazyKeySpec, LazyOpts } from "types/plugin/lazy";
import { Cache } from "./cache";
import { Command, CommandGroup, extendCommandsInGroup } from "./command";
import { Action } from "./action";
import { tblExtend } from "@core/utils";

export interface ExtendPluginOpts {
  /**
   * Commands to be registered for this plugin.
   */
  commands?: (Command | CommandGroup)[] | CommandGroup;
}

export type PluginOpts = {
  /**
   * Short url for the plugin
   */
  shortUrl: string;

  /**
   * Options for `lazy.nvim`
   */
  lazy?: LazyOpts;

  /**
   * All actions registered by this plugin.
   */
  providedActions?: Action[] | (() => Action[]);

  /**
   * Options for extending the plugin
   */
  extends?: ExtendPluginOpts;

  /**
   * Whether to allow this plugin can be used in `vscode-neovim`.
   *
   * Defaults to `false`.
   */
  allowInVscode?: boolean;

  /**
   * How many ms to delay the setup of the plugin.
   */
  delaySetup?: number;
};

function isCommand(cmd: Command | CommandGroup): cmd is Command {
  return "callback" in cmd;
}

export type LazySpec = {
  [1]: string;
} & LazyOpts;

export class Plugin {
  private _cache: Cache;

  constructor(private _opts: PluginOpts) {
    this._cache = new Cache();
  }

  public guessMain(): string {
    let name = this._opts.shortUrl;
    [name] = string.gsub(name.toLowerCase(), "^n?vim%-", "");
    [name] = string.gsub(name, "%.n?vim$", "");
    [name] = string.gsub(name, "%.lua$", "");
    [name] = string.gsub(name, "[^a-z]+", "");
    return name;
  }

  private _commands(): Command[] {
    if (!this._opts.extends) {
      return [];
    }
    if (!this._opts.extends.commands) {
      return [];
    }

    let defaultCategory = this.guessMain();

    let result: Command[] = [];
    if ("commands" in this._opts.extends.commands) {
      result = extendCommandsInGroup(this._opts.extends.commands, {
        category: defaultCategory,
      });
    } else {
      for (let cmd of this._opts.extends.commands) {
        if ("commands" in cmd) {
          for (let c of cmd.commands) {
            result.push(
              tblExtend(
                "keep",
                c,
                {
                  category: cmd.category,
                  enabled: cmd.enabled,
                },
                {
                  category: defaultCategory,
                }
              )
            );
          }
        } else {
          result.push(cmd);
        }
      }
    }

    return result;
  }

  get commands(): Command[] {
    return this._cache.ensure("commands", () => {
      return this._commands();
    });
  }

  get actions(): Action[] {
    return this._cache.ensure("actions", () => {
      if (!this._opts.providedActions) {
        return [];
      }
      if (typeof this._opts.providedActions === "function") {
        return this._opts.providedActions();
      }
      return this._opts.providedActions;
    });
  }

  private getMain(): string {
    if (this._opts.lazy?.main) {
      return this._opts.lazy.main;
    }
    return this.guessMain();
  }

  private generateConfigFn() {
    if (this._opts.delaySetup !== undefined) {
      let config = this._opts.lazy?.config;
      if (typeof config === "function") {
        return (p: AnyTable, opts: AnyTable) => {
          vim.defer_fn(() => {
            (config as (this: void, plug: AnyTable, opts: AnyTable) => void)(
              p,
              opts
            );
          }, this._opts.delaySetup!);
        };
      } else if (
        typeof this._opts.lazy?.config === "boolean" &&
        this._opts.lazy.config
      ) {
        return (_: AnyTable, opts: AnyTable) => {
          vim.defer_fn(() => {
            luaRequire(this.getMain()).setup(opts);
          }, this._opts.delaySetup!);
        };
      }
    }
    return this._opts.lazy?.config;
  }

  asLazySpec(): LazySpec | string {
    if (!this._opts.lazy && this.commands.length === 0) {
      return this._opts.shortUrl;
    }

    let keySpecs = this._opts.lazy?.keys ? this._opts.lazy.keys : [];
    if (!Array.isArray(keySpecs)) {
      keySpecs = [keySpecs];
    }
    for (let cmd of this.commands) {
      if (!cmd.keys) continue;
      let lhs = cmd.keys;
      if (!Array.isArray(lhs)) {
        lhs = [lhs];
      }
      for (let key of lhs) {
        let keySpec: LazyKeySpec = {
          [1]: key,
          [2]: cmd.callback,
          desc: cmd.shortDesc ? cmd.shortDesc : cmd.description,
        };
        keySpecs.push(keySpec);
      }
    }

    let opts = tblExtend("force", this._opts.lazy || {}, {
      keys: keySpecs,
    });
    opts.config = this.generateConfigFn();

    let result = {
      [1]: this._opts.shortUrl,
      ...opts,
    };
    return result;
  }
}
