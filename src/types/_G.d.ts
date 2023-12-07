declare function createGraphicsWidget(
  this: void,
  type: string | Function,
  props?: any,
  ...children: graphics.Widget[]
): graphics.Widget;

declare const graphicsWidgets: LuaTable;
