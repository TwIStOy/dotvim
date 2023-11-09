type MaybePromise<T> = T | Promise<T>;

export interface Command {
  name: string;
  description: string;
  category?: string;

  callback: () => MaybePromise<void>;
}
