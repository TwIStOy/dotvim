type MaybePromise<T> = T | Promise<T>;

export interface Command {
  /**
   * Dislay name for the command
   */
  name: string;
  /**
   * Description for the command
   */
  description?: string;
  /**
   * Category for the command
   */
  category?: string;

  /**
   * Callbacl when the command is executed
   */
  callback: string | ((this: void) => MaybePromise<void>);

  /**
   * Keys that can be used to trigger the command.
   *
   * This will be automatically added to its plugin's `lazy` field.
   */
  keys?: string | string[];

  /**
   * Short description of the command. To be used in `which-key` panel.
   */
  shortDesc?: string;
}

export interface CommandGroup {
}
