import { ifNil } from "@core/vim";

export class PangoSpanProperties {
  properties: LuaTable<string, string>;

  constructor(properties?: LuaTable<string, string>) {
    this.properties = ifNil(properties, new LuaTable<string, string>())!;
  }

  get(name: string): string | undefined {
    return this.properties.get(name);
  }

  set(name: string, value: string) {
    this.properties.set(name, value);
  }
}
