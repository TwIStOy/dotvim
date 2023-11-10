import instContext from "../../context";

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

export interface ExternalTools {
  /**
   * Name of tool/lsp_server.
   */
  name: string;

  /*
   * Tool install configuration.
   */
  exe: MasonPackageOpt | LocalToolOpt | AbsolutePathToolOpt | false;
}

export class Formatter implements ExternalTools {
  name: string;

  exe: MasonPackageOpt | LocalToolOpt | AbsolutePathToolOpt | false;

  /**
   * Supported filetypes.
   */
  ft?: string | string[];

  /*
   * Options for formatter.
   */
  opts?: Omit<conform.JobFormatterConfig, "command">;

  constructor(
    opts: ExternalTools & {
      ft?: string | string[];
      opts?: Omit<conform.JobFormatterConfig, "command">;
    }
  ) {
    this.name = opts.name;
    this.exe = opts.exe;
    this.ft = opts.ft;
    this.opts = opts.opts;
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
