import { Action, Cache } from "@core/model";
import { VimBuffer } from "@core/vim";

export abstract class Collection {
  protected _actions: Action<any>[] = [];
  protected _cache: Cache = new Cache();

  cosntructor() {}

  push(action: Action<any>): void {
    this._actions.push(action);
    this._cache.clear();
  }

  getActions(buffer: VimBuffer): Action<any>[] {
    return this._cache.ensure(buffer.asCacheKey(), () => {
      return this._actions.filter((action) => {
        return action.enabled(buffer);
      });
    });
  }

  abstract mount(buffer: VimBuffer, opt?: any): void;
}
