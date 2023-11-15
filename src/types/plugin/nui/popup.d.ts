// ---@alias nui_t_text_align 'left'|'center'|'right'
type NuiTextAlign = "left" | "center" | "right";

// ---@alias nui_popup_border_internal_type 'simple'|'complex'
type NuiPopupBorderInternalType = "simple" | "complex";

// ---@alias nui_popup_border_internal_position table<'row'|'col', number>
type NuiPopupBorderInternalPosition = {
  row?: number;
  col?: number;
};

// ---@alias nui_popup_border_internal_size table<'height'|'width', number>
type NuiPopupBorderInternalSize = {
  height?: number;
  width?: number;
};

// ---@alias nui_popup_border_internal_padding _nui_popup_border_option_padding_map
type NuiPopupBorderInternalPadding = NuiPopupBorderOptionPaddingMap;

// ---@alias nui_popup_border_internal_text { top?: NuiLine|NuiText, top_align?: nui_t_text_align, bottom?: NuiLine|NuiText, bottom_align?: nui_t_text_align }
type NuiPopupBorderInternalText = {
  top?: NuiLine | NuiText;
  top_align?: NuiTextAlign;
  bottom?: NuiLine | NuiText;
  bottom_align?: NuiTextAlign;
};

// ---@alias _nui_popup_border_internal_char table<_nui_popup_border_style_map_position, NuiText>
type NuiPopupBorderInternalChar = {
  top_left?: NuiText;
  top?: NuiText;
  top_right?: NuiText;
  right?: NuiText;
  bottom_right?: NuiText;
  bottom?: NuiText;
  bottom_left?: NuiText;
  left?: NuiText;
};

// ---@alias _nui_popup_border_option_padding_list table<1|2|3|4, integer>
type NuiPopupBorderOptionPaddingList = [number, number, number, number];

// ---@alias _nui_popup_border_option_padding_map table<'top'|'right'|'bottom'|'left', integer>
type NuiPopupBorderOptionPaddingMap = {
  top?: number;
  right?: number;
  bottom?: number;
  left?: number;
};

// ---@alias nui_popup_border_option_padding _nui_popup_border_option_padding_list|_nui_popup_border_option_padding_map
type NuiPopupBorderOptionPadding =
  | NuiPopupBorderOptionPaddingList
  | NuiPopupBorderOptionPaddingMap;

// ---@alias _nui_popup_border_style_char_tuple table<1|2, string>
type NuiPopupBorderOptionCharTuple = [string, string];

// ---@alias _nui_popup_border_style_char string|_nui_popup_border_style_char_tuple|NuiText
type NuiPopupBorderStyleChar = string | NuiPopupBorderOptionCharTuple | NuiText;

// ---@alias _nui_popup_border_style_builtin 'double'|'none'|'rounded'|'shadow'|'single'|'solid'
type NuiPopupBorderStyleBuiltin =
  | "double"
  | "none"
  | "rounded"
  | "shadow"
  | "single"
  | "solid";

// ---@alias _nui_popup_border_style_list table<1|2|3|4|5|6|7|8, _nui_popup_border_style_char>
type NuiPopupBorderStyleList = [
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
  NuiPopupBorderStyleChar,
];

// ---@alias _nui_popup_border_style_map_position 'top_left'|'top'|'top_right'|'right'|'bottom_right'|'bottom'|'botom_left'|'left'
// ---@alias _nui_popup_border_style_map table<_nui_popup_border_style_map_position, _nui_popup_border_style_char>
type NuiPopupBorderStyleMapPosition =
  | "top_left"
  | "top"
  | "top_right"
  | "right"
  | "bottom_right"
  | "bottom"
  | "botom_left"
  | "left";
type NuiPopupBorderStyleMap = {
  [key in NuiPopupBorderStyleMapPosition]?: NuiPopupBorderStyleChar;
};

// ---@alias nui_popup_border_option_style _nui_popup_border_style_builtin|_nui_popup_border_style_list|_nui_popup_border_style_map
declare type NuiPopupBorderOptionStyle =
  | NuiPopupBorderStyleBuiltin
  | NuiPopupBorderStyleList
  | NuiPopupBorderStyleMap;

/*
---@class nui_popup_border_internal
---@field type nui_popup_border_internal_type
---@field style nui_popup_border_option_style
---@field char _nui_popup_border_internal_char
---@field padding? _nui_popup_border_option_padding_map
---@field position nui_popup_border_internal_position
---@field size nui_popup_border_internal_size
---@field size_delta nui_popup_border_internal_size
---@field text? nui_popup_border_internal_text
---@field lines? NuiLine[]
---@field winhighlight? string
*/
type NuiPopupBorderInternal = {
  type: NuiPopupBorderInternalType;
  style: NuiPopupBorderOptionStyle;
  char: NuiPopupBorderInternalChar;
  padding?: NuiPopupBorderOptionPaddingMap;
  position: NuiPopupBorderInternalPosition;
  size: NuiPopupBorderInternalSize;
  size_delta: NuiPopupBorderInternalSize;
  text?: NuiPopupBorderInternalText;
  lines?: NuiLine[];
  winhighlight?: string;
};

// ---@alias _nui_popup_border_option_text_value string|NuiLine|NuiText|string[]|table<1|2, string>[]
type NuiPopupBorderOptionTextValue =
  | string
  | NuiLine
  | NuiText
  | string[]
  | [string, string];

// ---@alias nui_popup_border_option_text { top?: _nui_popup_border_option_text_value, top_align?: nui_t_text_align, bottom?: _nui_popup_border_option_text_value, bottom_align?: nui_t_text_align }
declare type NuiPopupBorderOptionText = {
  top?: NuiPopupBorderOptionTextValue;
  top_align?: NuiTextAlign;
  bottom?: NuiLine | NuiText;
  bottom_align?: NuiPopupBorderOptionTextValue;
};

/*
---@class nui_popup_border_options
---@field padding? nui_popup_border_option_padding
---@field style? nui_popup_border_option_style
---@field text? nui_popup_border_option_text
*/
declare type NuiPopupBorderOptions = {
  padding?: NuiPopupBorderOptionPadding;
  style?: NuiPopupBorderOptionStyle;
  text?: NuiPopupBorderOptionText;
};

/*
---@class NuiPopupBorder
---@field bufnr integer
---@field private _ nui_popup_border_internal
---@field private popup NuiPopup
---@field win_config nui_popup_win_config
---@field winid number
*/
declare interface NuiPopupBorder {
  bufnr: number;
  _: NuiPopupBorderInternal;
  popup: NuiPopup;
  win_config: NuiPopupWinConfig;
  winid: number;

  mount(): void;

  unmount(): void;

  set_text(
    edge: "top" | "bottom",
    text?: string | NuiText | NuiLine,
    align?: NuiTextAlign
  ): void;

  set_highlight(group: string): void;

  set_style(style: NuiPopupBorderOptionStyle): void;

  get(): NuiPopupBorderStyleBuiltin | NuiPopupBorderOptionCharTuple | null;
}

// ---@alias nui_popup_internal_position { relative: "'cursor'"|"'editor'"|"'win'", win: number, bufpos?: number[], row: number, col: number }
declare type NuiPopupInternalPosition = {
  relative: "cursor" | "editor" | "win";
  win: number;
  bufpos?: number[];
  row: number;
  col: number;
};

// ---@alias nui_popup_internal_size { height: number, width: number }
declare type NuiPopupInternalSize = {
  height: number;
  width: number;
};

// ---@alias nui_popup_win_config { focusable: boolean, style: "'minimal'", zindex: number, relative: "'cursor'"|"'editor'"|"'win'", win?: number, bufpos?: number[], row: number, col: number, width: number, height: number, border?: string|table, anchor?: nui_layout_option_anchor }
declare type NuiPopupWinConfig = {
  focusable: boolean;
  style: "minimal";
  zindex: number;
  relative: "cursor" | "editor" | "win";
  win?: number;
  bufpos?: number[];
  row: number;
  col: number;
  width: number;
  height: number;
  border?: string | NuiPopupBorderOptions;
  anchor?: NuiLayoutOptionAnchor;
};

/*
---@class nui_popup_internal
---@field augroup table<'hide'|'unmount', string>
---@field buf_options table<string, any>
---@field layout table, layout_ready: boolean
---@field loading boolean
---@field mounted boolean
---@field position nui_popup_internal_position
---@field size nui_popup_internal_size
---@field unmanaged_bufnr? boolean
---@field win_config nui_popup_win_config
---@field win_enter boolean
---@field win_options table<string, any>
*/
declare interface NuiPopupInternal {
  augroup: {
    hide?: string;
    unmount?: string;
  };
  buf_options: {
    [key: string]: any;
  };
  layout: {
    [key: string]: any;
  };
  layout_ready: boolean;
  loading: boolean;
  mounted: boolean;
  position: NuiPopupInternalPosition;
  size: NuiPopupInternalSize;
  unmanaged_bufnr?: boolean;
  win_config: NuiPopupWinConfig;
  win_enter: boolean;
  win_options: {
    [key: string]: any;
  };
}

/*
---@class nui_popup_options
---@field border? _nui_popup_border_style_builtin|nui_popup_border_options
---@field ns_id? string|integer
---@field anchor? nui_layout_option_anchor
---@field relative? nui_layout_option_relative_type|nui_layout_option_relative
---@field position? number|string|nui_layout_option_position
---@field size? number|string|nui_layout_option_size
---@field enter? boolean
---@field focusable? boolean
---@field zindex? integer
---@field buf_options? table<string, any>
---@field win_options? table<string, any>
---@field bufnr? integer
*/
declare interface NuiPopupOptions {
  border?: NuiPopupBorderOptions | NuiPopupBorderStyleBuiltin;
  ns_id?: string | number;
  anchor?: NuiLayoutOptionAnchor;
  relative?: NuiLayoutOptionRelativeType | NuiLayoutOptionRelative;
  position?: number | string | NuiLayoutOptionPosition;
  size?: number | string | NuiLayoutOptionSize;
  enter?: boolean;
  focusable?: boolean;
  zindex?: number;
  buf_options?: {
    [key: string]: any;
  };
  win_options?: {
    [key: string]: any;
  };
  bufnr?: number;
}

/*
---@class NuiPopup
---@field border NuiPopupBorder
---@field bufnr integer
---@field ns_id integer
---@field private _ nui_popup_internal
---@field win_config nui_popup_win_config
---@field winid number
*/
declare interface NuiPopup {
  border: NuiPopupBorder;
  bufnr: number;
  ns_id: number;
  _: NuiPopupInternal;
  win_config: NuiPopupWinConfig;
  winid: number;

  /**
   * Mounts the popup.
   */
  mount(): void;

  /**
   * Unmounts the popup.
   */
  unmount(): void;

  /**
   * Hides the popup window. Preserves the buffer (related content, autocmds and keymaps).
   */
  hide(): void;

  /**
   * Shows the popup window.
   */
  show(): void;

  /**
   * Sets keymap for the popup.
   */
  map(
    mode: string,
    lhs: string,
    handler: string | (() => void),
    opts?: {
      expr?: boolean;
      noremap?: boolean;
      nowait?: boolean;
      remap?: boolean;
      script?: boolean;
      silent?: boolean;
      unique?: boolean;
    }
  ): void;

  /**
   * Unsets keymap for the popup.
   */
  unmap(mode: string, lhs: string | string[]): void;

  /**
   * Sets autocmd for the popup.
   */
  on(
    event: string | string[],
    handler: string | (() => void),
    opts?: {
      once?: boolean;
      nested?: boolean;
    }
  ): void;

  /**
   * Unsets autocmd for the popup.
   */
  off(event: string | string[]): void;

  /**
   * Sets the layout of the popup. You can use this method to change popup's size or position after it's mounted.
   */
  update_layout(opts: NuiLayoutOptions): void;
}
