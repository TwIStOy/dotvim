import { GetRequired, Push, TupleToUnion } from "@core/type_traits";
import { VimBuffer } from "@core/vim";
import { LazyKeySpec } from "types/plugin/lazy";

export type ActionCondition = (buf: VimBuffer) => boolean;

interface ActionOptions<Id extends string> {
  id: Id;
  title: string;
  callback: string | ((this: void) => void);
  description?: string;
  icon?: string;
  condition?: ActionCondition;
  category?: string;
  keys?:
    | string
    | string[]
    | Pick<LazyKeySpec, 1 | "mode" | "ft" | "desc" | "silent">[];
  /**
   * Which plugin this action is from.
   */
  from?: string;
}

type RestKeys<Used extends (keyof ActionBuilder)[]> = Exclude<
  keyof ActionBuilder,
  TupleToUnion<Used>
>;

export class ActionBuilder<
  Used extends (keyof ActionBuilder)[] = [],
  Id extends string = "",
> {
  private _opts: ActionOptions<Id>;

  constructor() {
    this._opts = {
      id: "" as any,
      title: "",
      callback: () => {},
    };
  }

  static start() {
    return new ActionBuilder();
  }

  id<R extends string>(
    this: "id" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    id: R
  ) {
    this._opts.id = id as any;
    return this as unknown as ActionBuilder<Push<Used, "id">, R>;
  }

  title(
    this: "title" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    title: string
  ) {
    this._opts.title = title;
    return this as unknown as ActionBuilder<Push<Used, "title">, Id>;
  }

  callback(
    this: "callback" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    callback: string | ((this: void) => void)
  ) {
    this._opts.callback = callback;
    return this as unknown as ActionBuilder<Push<Used, "callback">, Id>;
  }

  description(
    this: "description" extends RestKeys<Used>
      ? ActionBuilder<Used, Id>
      : never,
    description: string
  ) {
    this._opts.description = description;
    return this as unknown as ActionBuilder<Push<Used, "description">, Id>;
  }

  icon(
    this: "icon" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    icon: string
  ) {
    this._opts.icon = icon;
    return this as unknown as ActionBuilder<Push<Used, "icon">, Id>;
  }

  condition(
    this: "condition" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    condition: ActionCondition
  ) {
    this._opts.condition = condition;
    return this as unknown as ActionBuilder<Push<Used, "condition">, Id>;
  }

  category(
    this: "category" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    category: string
  ) {
    this._opts.category = category;
    return this as unknown as ActionBuilder<Push<Used, "category">, Id>;
  }

  keys(
    this: "keys" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    keys: string | string[]
  ) {
    this._opts.keys = keys;
    return this as unknown as ActionBuilder<Push<Used, "keys">, Id>;
  }

  from(
    this: "from" extends RestKeys<Used> ? ActionBuilder<Used, Id> : never,
    from: string
  ) {
    this._opts.from = from;
    return this as unknown as ActionBuilder<Push<Used, "from">, Id>;
  }

  build(
    this: keyof GetRequired<ActionOptions<Id>> extends TupleToUnion<Used>
      ? ActionBuilder<Used, Id>
      : never
  ): Action<Id> {
    return new Action(this._opts);
  }
}

export type ActionList<Ids extends string[]> = Ids extends [infer F, ...infer R]
  ? F extends string
    ? R extends string[]
      ? [Action<F>, ...ActionList<R>]
      : never
    : never
  : [];

export type TraitActionId<A extends Action<any>> = A extends Action<infer Id>
  ? Id
  : never;

export type TraitActionsId<A extends Action<any>[]> = A extends [
  infer F,
  ...infer R,
]
  ? F extends Action<any>
    ? R extends Action<any>[]
      ? [TraitActionId<F>, ...TraitActionsId<R>]
      : never
    : never
  : [];

export class ActionGroupBuilder<Ids extends string[] = []> {
  private _sharedOptions: Pick<
    ActionOptions<any>,
    "category" | "from" | "condition"
  >;

  private _actions: Action<any>[] = [];

  constructor() {
    this._sharedOptions = {};
  }

  category(category: string) {
    this._sharedOptions.category = category;
    return this;
  }

  condition(condition: ActionCondition) {
    this._sharedOptions.condition = condition;
    return this;
  }

  from(from: string) {
    this._sharedOptions.from = from;
    return this;
  }

  private _update<R extends string>(action: Action<R>) {
    if (this._sharedOptions.category && !action.opts.category) {
      action.opts.category = this._sharedOptions.category;
    }
    if (this._sharedOptions.condition && !action.opts.condition) {
      action.opts.condition = this._sharedOptions.condition;
    }
    if (this._sharedOptions.from && !action.opts.from) {
      action.opts.from = this._sharedOptions.from;
    }
  }

  public add<Id extends string>(action: Action<Id>) {
    this._actions.push(action);
    return this as unknown as ActionGroupBuilder<Push<Ids, Id>>;
  }

  public addOpts<Id extends string>(opts: ActionOptions<Id>) {
    this._actions.push(new Action(opts));
    return this as unknown as ActionGroupBuilder<Push<Ids, Id>>;
  }

  public build() {
    return this._actions.map((action) => {
      this._update(action);
      return action;
    }) as ActionList<Ids>;
  }
}

export class Action<Id extends string> {
  constructor(public opts: ActionOptions<Id>) {}

  public get id() {
    return this.opts.id;
  }

  public get title() {
    return this.opts.title;
  }

  public get icon() {
    return this.opts.icon;
  }

  public get description() {
    return this.opts.description;
  }

  execute() {
    if (typeof this.opts.callback === "string") {
      vim.api.nvim_command(this.opts.callback);
    } else {
      this.opts.callback();
    }
  }

  enabled(buf: VimBuffer) {
    return this.opts.condition ? this.opts.condition(buf) : true;
  }

  printDescription() {
    if (this.opts.description) {
      print(`${this.opts.description}`);
    }
  }

  normalizeKeys(): LazyKeySpec[] {
    let ret: LazyKeySpec[] = [];
    if (this.opts.keys) {
      let keys = this.opts.keys;
      if (typeof keys === "string") {
        ret = [{ [1]: keys, [2]: this.opts.callback }];
      } else {
        for (let key of keys) {
          if (typeof key === "string") {
            ret.push({ [1]: key, [2]: this.opts.callback });
          } else {
            ret.push({ ...key, [2]: this.opts.callback });
          }
        }
      }
    }
    return ret;
  }
}

export class ActionRegistry {
  private _actions: Map<string, Action<any>> = new Map();

  constructor() {}

  public add(action: Action<any>) {
    if (this._actions.has(action.id)) {
      throw new Error(`Action ${action.id} already exists`);
    }
    this._actions.set(action.id, action);
  }

  public get(id: string) {
    return this._actions.get(id);
  }

  public get actions() {
    return this._actions.values();
  }
}
