import { VimBuffer, ifNil, isNil } from "@core/vim";
import { Collection } from "./collection";
import { ContextMenu } from "@core/components/context-menu";
import { MenuItem } from "@core/components/menu-item";
import { Command, invokeCommand } from "@core/types";
import { ExcludeNil } from "@core/type_traits";
import { RightClickPathElement, RightClickPathPart } from "@core/components";

type PathElement = ExcludeNil<Required<RightClickPathElement>>;

export class MenuItemPathMap {
  public next: Map<string, MenuItemPathMap> = new Map();
  public items: { item: MenuItem; index: number }[] = [];
  public readonly title: string;
  public index: number;
  public readonly depth: number;

  constructor(title?: string, index?: number, depth?: number) {
    this.title = ifNil(title, "");
    this.index = ifNil(index, 0);
    this.depth = ifNil(depth, 0);
  }

  public push(path: RightClickPathElement[], item: MenuItem, index: number) {
    if (path.length === this.depth) {
      this.items.push({ item, index });
    } else {
      let next = this.next.get(path[this.depth].title);
      if (isNil(next)) {
        next = new MenuItemPathMap(
          path[this.depth].title,
          path[this.depth].index,
          this.depth + 1
        );
        this.next.set(path[this.depth].title, next);
      }
      next.index = Math.max(next.index, path[this.depth].index ?? 0);
      next.push(path, item, index);
    }
  }

  public complete(): MenuItem[] {
    let ret = [...this.items];

    for (let [k, v] of this.next) {
      let ele = new MenuItem(k, () => {}, {
        children: v.complete(),
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
  mount(buffer: VimBuffer, opt?: any): void {
    let menu = new ContextMenu(this.getMenuItems(buffer));
    menu.asNuiMenu(opt ?? {}).mount();
  }

  getMenuItems(buffer: VimBuffer) {
    return this._cache.ensure(buffer.asCacheKey(), () =>
      this._getMenuItems(buffer)
    );
  }

  _getMenuItems(buffer: VimBuffer) {
    let commands = this.getCommands(buffer);
    let pathMap = new MenuItemPathMap();
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
    item: new MenuItem(ifNil(cmd.rightClick?.title, cmd.name), callback),
    path: ifNil(cmd.rightClick?.path, []).map(normPathElement),
    index: ifNil(cmd.rightClick?.index, 0),
  };
}

function normPathElement(e: RightClickPathPart): PathElement {
  if (typeof e === "string") {
    return {
      title: e,
      index: 0,
    };
  }
  return {
    title: e.title,
    index: ifNil(e.index, 0),
  };
}
