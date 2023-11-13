import instContext from "../context";
import { LazySpec } from "./plugin";

export interface MasonPackageOpt {
  /**
   * Name of package.
   */
  masonPkg: string;
  /**
   * Version of package.
   */
  masonVersion?: string;
}

export interface LocalToolOpt {
  /**
   * Absolute path of tool.
   */
  command: string[];
}

export interface AbsolutePathToolOpt {
  /**
   * Absolute path of tool.
   */
  path: string;
}

export interface ExternalToolsOpt {
  /**
   * Name of tool/lsp_server.
   */
  name: string;

  /*
   * Tool install configuration.
   */
  exe: MasonPackageOpt | LocalToolOpt | AbsolutePathToolOpt | false;
}

class ExternalTools implements ExternalToolsOpt {
  name: string;
  exe: MasonPackageOpt | LocalToolOpt | AbsolutePathToolOpt | false;

  constructor(opts: ExternalToolsOpt) {
    this.name = opts.name;
    this.exe = opts.exe;
  }

  asMasonSpec(): {
    name: string;
    version?: string;
  } | null {
    if (this.exe === false) {
      return null;
    }
    if ("masonPkg" in this.exe) {
      return {
        name: this.exe.masonPkg,
        version: this.exe.masonVersion,
      };
    }
    return null;
  }

  get executable(): string {
    if (this.exe === false) {
      return this.name;
    }
    if ("command" in this.exe) {
      return this.exe.command.join(" ");
    } else if ("masonPkg" in this.exe) {
      return `${instContext.masonBinRoot}/${this.exe.masonPkg}`;
    } else {
      return this.exe.path;
    }
  }
}

export class Formatter extends ExternalTools {
  /**
   * Supported filetypes.
   */
  ft?: string | string[];

  /*
   * Options for formatter.
   */
  opts?: Omit<conform.JobFormatterConfig, "command">;

  constructor(
    opts: ExternalToolsOpt & {
      ft?: string | string[];
      opts?: Omit<conform.JobFormatterConfig, "command">;
    }
  ) {
    super(opts);
    this.ft = opts.ft;
    this.opts = opts.opts;
  }

  asConformSpec(): conform.JobFormatterConfig {
    const opts = this.opts || {};
    return {
      command: this.executable,
      args: opts.args,
      range_args: opts.range_args,
      cwd: opts.cwd,
      require_cwd: opts.require_cwd,
      stdin: opts.stdin,
      exit_codes: opts.exit_codes,
      env: opts.env,
      condition: opts.condition,
    };
  }
}

type LspServerSetupFn = (
  server: LspServer,
  on_attach: () => void,
  capabilities: LuaTable
) => void;

type LspServerOpt = (
  | {
      setup: LspServerSetupFn;
    }
  | {
      ft: string[];
      settings?: LuaTable;
    }
) & {
  /**
   * where the lsp server is from
   */
  plugin?: LazySpec | string;
};

export class LspServer extends ExternalTools {
  readonly setup: LspServerSetupFn;
  readonly plugin?: LazySpec | string;

  constructor(opts: ExternalToolsOpt & LspServerOpt) {
    super(opts);
    if ("setup" in opts) {
      this.setup = opts.setup;
    } else {
      this.setup = LspServer._generateDefaultSetupFn(opts.ft, opts.settings);
    }
    this.plugin = opts.plugin;
  }

  static _generateDefaultSetupFn(
    ft: string[],
    settings?: LuaTable
  ): LspServerSetupFn {
    return (server, on_attach, capabilities) => {
      luaRequire("lspconfig").sourcekit.setup({
        cmd: [server.executable],
        filetypes: ft,
        on_attach: on_attach,
        capabilities: capabilities,
        settings: settings,
      });
    };
  }

  asLazySpec(): LazySpec | string | undefined {
    return this.plugin;
  }
}
