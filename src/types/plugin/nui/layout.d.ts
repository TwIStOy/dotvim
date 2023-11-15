/*
---@class nui_layout_options
---@field anchor? nui_layout_option_anchor
---@field relative? nui_layout_option_relative_type|nui_layout_option_relative
---@field position? number|string|nui_layout_option_position
---@field size? number|string|nui_layout_option_size
*/
declare interface NuiLayoutOptions {
  anchor?: NuiLayoutOptionAnchor;
  relative?: NuiLayoutOptionRelativeType | NuiLayoutOptionRelative;
  position?: number | string | NuiLayoutOptionPosition;
  size?: number | string | NuiLayoutOptionSize;
}

// ---@alias nui_layout_option_anchor "NW"|"NE"|"SW"|"SE"
declare type NuiLayoutOptionAnchor = "NW" | "NE" | "SW" | "SE";

// ---@alias nui_layout_option_relative_type "'cursor'"|"'editor'"|"'win'"|"'buf'"
declare type NuiLayoutOptionRelativeType = "cursor" | "editor" | "win" | "buf";

// ---@alias nui_layout_option_relative { type: nui_layout_option_relative_type, winid?: number, position?: { row: number, col: number }  }
declare interface NuiLayoutOptionRelative {
  type: NuiLayoutOptionRelativeType;
  winid?: number;
  position?: { row: number; col: number };
}

// ---@alias nui_layout_option_position { row: number|string, col: number|string }
declare interface NuiLayoutOptionPosition {
  row: number | string;
  col: number | string;
}

// ---@alias nui_layout_option_size { width: number|string, height: number|string }
declare interface NuiLayoutOptionSize {
  width: number | string;
  height: number | string;
}

// ---@alias nui_layout_internal_position { relative: "'cursor'"|"'editor'"|"'win'", win: number, bufpos?: number[], row: number, col: number }
declare interface NuiLayoutInternalPosition {
  relative: "cursor" | "editor" | "win";
  win: number;
  bufpos?: number[];
  row: number;
  col: number;
}

// ---@alias nui_layout_container_info { relative: nui_layout_option_relative_type, size: { height: integer, width: integer }, type: "'editor'"|"'window'" }
declare interface NuiLayoutContainerInfo {
  relative: NuiLayoutOptionRelativeType;
  size: { height: number; width: number };
  type: "editor" | "window";
}
