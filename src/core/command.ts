type MaybePromise<T> = T | Promise<T>;

export interface Command {
  name: string;
  description: string;
  category?: string;

  callback: string | ((this: void) => MaybePromise<void>);
}
