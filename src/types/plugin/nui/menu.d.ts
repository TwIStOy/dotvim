// ---@alias nui_menu_prepare_item nui_tree_prepare_node
declare type NuiMenuPrepareItem<T, U> = NuiTreePrepareNode<T, U>;

// ---@alias nui_menu_should_skip_item fun(node: NuiTree.Node): boolean
declare type NuiMenuShouldSkipItem<T> = (
  this: void,
  node: NuiTreeNode<T>
) => boolean;

// ---@alias _nui_menu_keymap_action 'close'|'focus_next'|'focus_prev'|'submit'
type NuiMenuKeymapAction = "close" | "focus_next" | "focus_prev" | "submit";

/*
---@class nui_menu_internal: nui_popup_internal
---@field items NuiTree.Node[]
---@field keymap table<_nui_menu_keymap_action, string[]>
---@field sep { char?: string|NuiText, text_align?: nui_t_text_align } # deprecated
---@field prepare_item nui_menu_prepare_item
---@field should_skip_item nui_menu_should_skip_item
---@field on_change fun(item: NuiTree.Node): nil
*/
declare interface NuiMenuInternal<T> extends NuiPopupInternal {
  items: NuiTreeNode<T>[];
  keymap: {
    [key in NuiMenuKeymapAction]?: string[];
  };
  /// @deprecated
  sep: {
    char?: string | NuiText;
    text_align?: NuiTextAlign;
  };
  prepare_item: NuiMenuPrepareItem<T, any>;
  should_skip_item: NuiMenuShouldSkipItem<T>;
  on_change: (item: NuiTreeNode<T>) => void;
}

/*
---@class nui_menu_options
---@field lines NuiTree.Node[]
---@field prepare_item? nui_tree_prepare_node
---@field should_skip_item? nui_menu_should_skip_item
---@field max_height? integer
---@field min_height? integer
---@field max_width? integer
---@field min_width? integer
---@field keymap? table<_nui_menu_keymap_action, string|string[]>
---@field on_change? fun(item: NuiTree.Node, menu: NuiMenu): nil
---@field on_close? fun(): nil
---@field on_submit? fun(item: NuiTree.Node): nil
*/
declare interface NuiMenuOptions<T> {
  lines: NuiTreeNode<T>[];
  prepare_item?: NuiMenuPrepareItem<T, any>;
  should_skip_item?: NuiMenuShouldSkipItem<T>;
  max_height?: number;
  min_height?: number;
  max_width?: number;
  min_width?: number;
  keymap?: {
    [key in NuiMenuKeymapAction]?: string | string[];
  };
  on_change?: (this: void, item: NuiTreeNode<T>, menu: NuiMenu<T>) => void;
  on_close?: (this: void) => void;
  on_submit?: (this: void, item: NuiTreeNode<T>) => void;
}

declare interface NuiMenu<T> extends NuiPopup {
  _: NuiMenuInternal<T>;

  menu_props: LuaTable & {
    on_submit: (this: void) => void;
    on_close: (this: void) => void;
    on_focus_next: (this: void) => void;
    on_focus_prev: (this: void) => void;
  };

  tree: NuiTree<T>;

  mount(): void;

  unmount(): void;
}

/*

*/
/*

*/
/*

*/
/*

*/
