import { GetRequired, Push, TupleToUnion } from "@core/type_traits";
import { VimBuffer } from "@core/vim";

export type ActionCondition = (buf: VimBuffer) => boolean;

interface ActionOptions {
  id: string;
  title: string;
  callback: string | ((this: void) => void);
  description?: string;
  icon?: string;
  condition?: ActionCondition;
  category?: string;
  /**
   * Which plugin this action is from.
   */
  from?: string;
}

type RestKeys<Used extends (keyof ActionBuilder)[]> = Exclude<
  keyof ActionBuilder,
  TupleToUnion<Used>
>;

export class ActionBuilder<Used extends (keyof ActionBuilder)[] = []> {
  private _opts: ActionOptions;

  constructor() {
    this._opts = {
      id: "",
      title: "",
      callback: () => {},
    };
  }

  id(
    this: "id" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    id: string
  ) {
    this._opts.id = id;
    return this as unknown as ActionBuilder<Push<Used, "id">>;
  }

  title(
    this: "title" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    title: string
  ) {
    this._opts.title = title;
    return this as unknown as ActionBuilder<Push<Used, "title">>;
  }

  callback(
    this: "callback" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    callback: string | ((this: void) => void)
  ) {
    this._opts.callback = callback;
    return this as unknown as ActionBuilder<Push<Used, "callback">>;
  }

  description(
    this: "description" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    description: string
  ) {
    this._opts.description = description;
    return this as unknown as ActionBuilder<Push<Used, "description">>;
  }

  icon(
    this: "icon" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    icon: string
  ) {
    this._opts.icon = icon;
    return this as unknown as ActionBuilder<Push<Used, "icon">>;
  }

  condition(
    this: "condition" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    condition: ActionCondition
  ) {
    this._opts.condition = condition;
    return this as unknown as ActionBuilder<Push<Used, "condition">>;
  }

  category(
    this: "category" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    category: string
  ) {
    this._opts.category = category;
    return this as unknown as ActionBuilder<Push<Used, "category">>;
  }

  from(
    this: "from" extends RestKeys<Used> ? ActionBuilder<Used> : never,
    from: string
  ) {
    this._opts.from = from;
    return this as unknown as ActionBuilder<Push<Used, "from">>;
  }

  build(
    this: keyof GetRequired<ActionOptions> extends TupleToUnion<Used>
      ? ActionBuilder<Used>
      : never
  ): Action {
    return new Action(this._opts);
  }
}

export class ActionGroupBuilder {
  private _sharedOptions: Pick<
    ActionOptions,
    "category" | "from" | "condition"
  >;

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

  updateActions(actions: Action[]) {
    for (let action of actions) {
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
  }
}

export class Action {
  constructor(public opts: ActionOptions) {}

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
}
