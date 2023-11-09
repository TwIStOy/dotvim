export class Context {
  public masonRoot: string;

  public lazyRoot: String;

  constructor() {
    this.masonRoot = vim.fn.stdpath("data") + "/mason";
    this.lazyRoot = vim.fn.stdpath("cache") + "/lazy/lazy.nvim";
  }

  get masonBinRoot(): string {
    return this.masonRoot + "/bin";
  }
}
