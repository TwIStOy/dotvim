export interface RightClickPathElement {
  /**
   * Displayed name
   */
  title: string;

  /**
   * Idx
   */
  index?: number;
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
}
