import { isNil } from "@core/vim";

function createGraphicsWidget(
  this: void,
  type: string | Function,
  props?: any,
  ...children: graphics.Widget[]
): graphics.Widget {
  if (typeof type === "string") {
    let builder = (_G as any).graphicsWidgets.get(type);
    if (isNil(builder)) {
      throw new Error("Unknown widget type: " + type);
    }
    return builder(props, ...children);
  } else {
    return type(props, ...children);
  }
}

export function registerWidget(name: string, widget: Function) {
  if ((_G as any).graphicsWidgets === null) {
    (_G as any).graphicsWidgets = new LuaTable();
  }
  ((_G as any).graphicsWidgets as LuaTable).set(name, widget);
}

_G.createGraphicsWidget = createGraphicsWidget;
