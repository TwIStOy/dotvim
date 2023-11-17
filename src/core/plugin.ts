import { Cache } from "./cache";
import {
  LazyKeySpec,
  LazyOpts,
  Command,
  CommandGroup,
  extendCommandsInGroup,
} from "./types";
import { tblExtend } from "./utils/table";

export type AutocmdLazyEvent = "VeryLazy" | AutocmdEvent | LspEvents;

export interface ExtendPluginOpts {
  /**
   * Whether to allow this plugin can be used in `vscode-neovim`.
   *
   * Defaults to `false`.
   */
  allowInVscode?: boolean;

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
   * Options for extending the plugin
   */
  extends?: ExtendPluginOpts;

  /**
   * Options for enable extra helpers
   */
  extra?: {
    /**
     * How many ms to delay the setup of the plugin.
     */
    delaySetup?: number;
  };
};

function isCommand(cmd: Command | CommandGroup): cmd is Command {
  return "callback" in cmd;
}

export type LazySpec = {
  [1]: string;
} & LazyOpts;

export class Plugin {
  private _opts: PluginOpts;
  private _cache: Cache;

  constructor(opts: PluginOpts) {
    this._opts = opts;
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

    if (
      typeof opts.config === "function" &&
      (this._opts.extra?.delaySetup ?? 0) > 0
    ) {
      let rawConfig = opts.config;
      opts.config = (plug, o) => {
        vim.defer_fn(
          () => {
            rawConfig(plug, o);
          },
          this._opts.extra?.delaySetup!
        );
      };
    }

    let result = {
      [1]: this._opts.shortUrl,
      ...opts,
    };
    return result;
  }
}
