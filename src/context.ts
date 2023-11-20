export class HttsContext {
  private static instance: HttsContext;

  public masonRoot: string;
  public lazyRoot: String;

  public static getInstance(): HttsContext {
    if (!HttsContext.instance) {
      HttsContext.instance = new HttsContext();
    }

    return HttsContext.instance;
  }

  private constructor() {
    this.masonRoot = vim.fn.stdpath("data") + "/mason";
    this.lazyRoot = vim.fn.stdpath("cache") + "/lazy/lazy.nvim";
  }

  get masonBinRoot(): string {
    return this.masonRoot + "/bin";
  }
}
