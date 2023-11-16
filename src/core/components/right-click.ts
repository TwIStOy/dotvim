export interface RightClickPathElement {
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

export type RightClickPathPart = string | RightClickPathElement;

export interface RightClickOpt {
  /**
   * Displayed name
   */
  title?: string;

  /**
   *
   */
  path?: RightClickPathPart[];

  /**
   * Idx
   */
  index?: number;

  /**
   * keys
   */
  keys?: string[];
}
