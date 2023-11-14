import { uniqueArray } from "../utils/array";
import { MenuText } from "./menu-text";

/**
 * A menu item component.
 */
export class MenuItem {
  public text: MenuText;
  public children: MenuItem[];
  public description?: string;

  private _keys: string[];

  constructor(
    text: string | MenuText,
    options?: {
      children?: MenuItem[];
      description?: string;
      keys?: string[];
    }
  ) {
    this.text = typeof text === "string" ? new MenuText(text) : text;
    this.children = options?.children ?? [];
    this.description = options?.description;

    this._keys = uniqueArray([...this.text.keys, ...(options?.keys ?? [])]);
  }
}
