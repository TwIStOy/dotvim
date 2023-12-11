class PangoSpanProperties {
  properties: LuaTable<string, string> = new LuaTable();

  get(name: string): string | undefined {
    return this.properties.get(name);
  }

  set(name: string, value: string) {
    this.properties.set(name, value);
  }
}
