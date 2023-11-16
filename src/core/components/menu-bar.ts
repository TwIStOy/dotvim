export interface MenuBarPathElement {
  /**
   * Displayed name
   */
  title: string;

  /**
   * Idx
   */
  index?: number;

  /**
   * keymaps
   */
  keys?: string[];
}

export type MenuBarPathPart = string | MenuBarPathElement;

export interface MenuBarOpt {
  title: string;
  /**
   * Path to the menu item.
   */
  path?: MenuBarPathPart[];
  /**
   * Icon for the menu item.
   */
  icon?: string;
  /**
   * Keys that can be used to trigger the command.
   */
  keys?: string[];
}
