export class Cache {
  private entries: Map<string, any> = new Map();

  constructor() {}

  private normalizeKey(key: any): string {
    return vim.json.encode(key);
  }

  public get(key: any): AnyNotNil {
    return this.entries.get(this.normalizeKey(key));
  }

  public clear(): void {
    this.entries.clear();
  }

  public contains(key: any): boolean {
    return this.entries.has(this.normalizeKey(key));
  }

  public set(key: any, value: any): void {
    this.entries.set(this.normalizeKey(key), value);
  }

  public ensure<T>(key: any, callback: () => T): T {
    let value: T;
    if (this.contains(key)) {
      value = this.get(key) as T;
    } else {
      value = callback();
      this.set(key, value);
    }
    return value;
  }
}
