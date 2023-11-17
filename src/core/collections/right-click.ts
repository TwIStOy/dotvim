/** @noSelfInFile */

import { VimBuffer, ifNil, isNil } from "@core/vim";
import { Collection } from "./collection";
import { ContextMenu } from "@core/components/context-menu";
import { MenuItem } from "@core/components/menu-item";
import { Command, invokeCommand } from "@core/types";
import { ExcludeNil } from "@core/type_traits";
import { RightClickPathElement, RightClickPathPart } from "@core/components";
import { uniqueArray } from "@core/utils";

type PathElement = ExcludeNil<Required<RightClickPathElement>>;

export class MenuItemPathMap {
  public next: Map<string, MenuItemPathMap> = new Map();
  public items: { item: MenuItem; index: number }[] = [];
  public readonly title: string;
  public index: number;
  public keys: string[];
  public readonly depth: number;

  constructor(opts: {
    title?: string;
    index?: number;
    depth?: number;
    keys?: string[];
  }) {
    this.title = ifNil(opts.title, "");
    this.index = ifNil(opts.index, 0);
    this.depth = ifNil(opts.depth, 0);
    this.keys = ifNil(opts.keys, []);
  }

  private _updateInfo(ele: RightClickPathElement) {
    this.index = Math.max(this.index, ele.index ?? 0);
    this.keys = uniqueArray([...this.keys, ...(ele.keys ?? [])]);
  }

  public push(path: RightClickPathElement[], item: MenuItem, index: number) {
    if (path.length === this.depth) {
      this.items.push({ item, index });
    } else {
      let next = this.next.get(path[this.depth].title);
      if (isNil(next)) {
        next = new MenuItemPathMap({
          title: path[this.depth].title,
          index: path[this.depth].index,
          depth: this.depth + 1,
          keys: path[this.depth].keys,
        });
        this.next.set(path[this.depth].title, next);
      }
      next._updateInfo(path[this.depth]);
      next.push(path, item, index);
    }
  }

  public complete(): MenuItem[] {
    let ret = [...this.items];

    for (let [k, v] of this.next) {
      let ele = new MenuItem(k, () => {}, {
        children: v.complete(),
        keys: v.keys,
      });
      ret.push({
        index: v.index,
        item: ele,
      });
    }

    return ret.sort((a, b) => a.index - b.index).map((item) => item.item);
  }
}

export class RightClickPaletteCollection extends Collection {
  mount(buffer: VimBuffer, opt?: any): boolean {
    let items = this.getMenuItems(buffer);
    if (items.length > 0) {
      let menu = new ContextMenu(items);
      vim.schedule(() => {
        menu.asNuiMenu(opt ?? {}).mount();
      });
    }
    return items.length > 0;
  }

  getMenuItems(buffer: VimBuffer) {
    return this._cache.ensure(buffer.asCacheKey(), () =>
      this._getMenuItems(buffer)
    );
  }

  _getMenuItems(buffer: VimBuffer) {
    let commands = this.getCommands(buffer);
    let pathMap = new MenuItemPathMap({});
    for (let cmd of commands) {
      if (isNil(cmd.rightClick)) {
        continue;
      }
      let info = commandToItemInfo(cmd);
      pathMap.push(info.path, info.item, info.index);
    }
    return pathMap.complete();
  }
}

type ItemInfo = {
  item: MenuItem;
  path: PathElement[];
  index: number;
};

function commandToItemInfo(cmd: Command): ItemInfo {
  let callback = () => invokeCommand(cmd);
  if (cmd.rightClick === true) {
    return {
      item: new MenuItem(cmd.name, callback),
      path: [],
      index: 0,
    };
  }
  return {
    item: new MenuItem(ifNil(cmd.rightClick?.title, cmd.name), callback, {
      keys: cmd.rightClick?.keys,
      description: cmd.description,
    }),
    path: ifNil(cmd.rightClick?.path, []).map((v) => {
      return normPathElement(v);
    }),
    index: ifNil(cmd.rightClick?.index, 0),
  };
}

function normPathElement(e: RightClickPathPart): PathElement {
  if (typeof e === "string") {
    return {
      title: e,
      index: 0,
      keys: [],
    };
  }
  return {
    title: e.title,
    index: ifNil(e.index, 0),
    keys: e.keys ?? [],
  };
}
