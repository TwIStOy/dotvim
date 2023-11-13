export interface MenubarOpt {
  text: string;
  /**
   * Path to the menu item.
   */
  path: string[];
  /**
   * Icon for the menu item.
   */
  icon?: string;
  /**
   * Keys that can be used to trigger the command.
   */
  keys?: string | string[];
}
