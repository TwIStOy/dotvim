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

  build(
    this: keyof GetRequired<ActionOptions> extends TupleToUnion<Used>
      ? ActionBuilder<Used>
      : never
  ): Action {
    return new Action(this._opts);
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
