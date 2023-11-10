/** @noSelfInFile */

import { Command } from "./command";
import { RightClickSection } from "./right_click";

export interface LazyKeySpec {
  /**
   * lhs
   */
  [1]: string;
  /*
   * rhs
   */
  [2]?: string | (() => void);
  /**
   * mode, defaults to 'n'
   */
  mode?: string | string[];
  /**
   * `filetype` for buffer-local keymaps
   */
  ft?: string | string[];

  /**
   * description
   */
  desc?: string;
}

export interface LazyOpts {
  /**
   * A directory pointing to a local plugin
   */
  dir?: string;

  /**
   * A custom git url where the plugin is hosted
   */
  url?: string;

  /**
   * A custom name for the plugin used for the local plugin directory and as
   * the display name
   */
  name?: string;

  /**
   * When true, a local plugin directory will be used instead.
   */
  dev?: boolean;

  /**
   * When true, the plugin will only be loaded when needed. Lazy-loaded plugins
   * are automatically loaded when their Lua modules are required, or when one
   * of the lazy-loading handlers triggers
   */
  lazy?: boolean;

  /**
   * When false, or if the function returns false, then this plugin will not
   * be included in the spec
   */
  enabled?: boolean | ((this: void) => boolean);

  /**
   * When false, or if the function returns false, then this plugin will not
   * be loaded. Useful to disable some plugins in vscode, or firenvim for
   * example.
   */
  cond?: boolean | ((this: void, plug: LazyOpts) => boolean);

  /**
   * A list of plugin names or plugin specs that should be loaded when the
   * plugin loads. Dependencies are always lazy-loaded unless specified
   * otherwise. When specifying a name, make sure the plugin spec has been
   * defined somewhere else.
   */
  dependencies?: string[];

  /**
   * `init` functions are always executed during startup
   */
  init?: (this: void, plug: LazyOpts) => void;

  /**
   * `opts` should be a table (will be merged with parent specs), return a
   * table (replaces parent specs) or should change a table. The table will be
   * passed to the `Plugin.config()` function. Setting this value will imply
   * `Plugin.config()`
   */
  opts?: AnyTable | ((this: void, plug: LazyOpts, opts: AnyTable) => AnyTable);

  /**
   * `config` is executed when the plugin loads. The default implementation
   * will automatically run `require(MAIN).setup(opts)`.
   * Lazy uses several heuristics to determine the plugin's `MAIN` module
   * automatically based on the plugin's name.
   */
  config?: true | ((this: void, plug: AnyTable, opts: AnyTable) => void);

  /**
   * You can specify the `main` module to use for `config()` and `opts()`,
   * in case it can not be determined automatically.
   */
  main?: string;

  /**
   * Only useful for start plugins `(lazy=false)` to force loading certain
   * plugins first. Default priority is `50`.
   * It's recommended to set this to a high number for colorschemes.
   */
  priority?: number;

  /**
   * Lazy-load on key mapping
   */
  keys?: string | (LazyKeySpec | string)[];

  /**
   * Lazy-load on filetype
   */
  ft?:
    | string
    | string[]
    | ((this: void, plug: AnyTable, ft: string[]) => string[]);

  /**
   * Lazy-load on command
   */
  cmd?:
    | string
    | string[]
    | ((this: void, plug: AnyTable, cmd: string[]) => string[]);

  /**
   * Lazy-load on event. Events can be specified as `BufEnter` or with a pattern like `BufEnter *.lua`
   */
  event?:
    | string
    | string[]
    | ((this: void, plug: AnyTable, event: string[]) => string[])
    | {
        event: string | string[];
        pattern?: string | string[];
      };

  /**
   * When false, git submodules will not be fetched. Defaults to `true`
   */
  submodules?: boolean;

  /**
   * When true, this plugin will not be included in updates
   */
  pin?: boolean;

  /**
   * Branch of the repository
   */
  branch?: string;

  /**
   * Commit of the repository
   */
  commit?: string;

  /**
   * Tag of the repository
   */
  tag?: string;

  /**
   * Version to use from the repository. Full Semver ranges are supported
   */
  version?: string | false;
}

export interface FullLazySpec extends LazyOpts {
  /**
   * Short url for the plugin
   */
  [1]: string;
}

export interface PluginCommandsOpts {
  /**
   * Commands to be registered for this plugin.
   */
  commands: Command[];
  /**
   * Default category for all commands in this plugin.
   */
  category?: string;
}

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
  commands?: Command[] | PluginCommandsOpts;

  /**
   * Right-click menu sections to be registered for this plugin.
   */
  rightClickSections?: RightClickSection[];
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
};

export class Plugin {
  private _opts: PluginOpts;

  constructor(opts: PluginOpts) {
    this._opts = opts;
  }

  get commands(): Command[] {
    if (!this._opts.extends) {
      return [];
    }
    if (!this._opts.extends.commands) {
      return [];
    }
    if (Array.isArray(this._opts.extends.commands)) {
      return this._opts.extends.commands;
    }
    return this._opts.extends.commands.commands;
  }

  asLazySpec(): string | FullLazySpec {
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
    let opts = vim.tbl_extend("force", this._opts.lazy || {}, {
      keys: keySpecs,
    });

    let result = {
      [1]: this._opts.shortUrl,
      ...opts,
    };
    return result;
  }
}
