export interface MasonPackageOpt {
  /**
   * Name of package.
   */
  name: string;
  /**
   * Version of package.
   */
  version?: string;
}

export interface LocalToolOpt {
  /**
   * Absolute path of tool.
   */
  path: string;
}

export class ToolOpt {
  /**
   * Name of tool/lsp_server.
   */
  public name: string;
  /**
   * Package configuration.
   */
  public conf?: MasonPackageOpt | LocalToolOpt;

  constructor(name: string, conf?: MasonPackageOpt | LocalToolOpt) {
    this.name = name;
    this.conf = conf;
  }
}
