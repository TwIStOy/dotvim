/*
---@class nui_input_options
---@field prompt? string|NuiText
---@field default_value? string
---@field on_change? fun(value: string): nil
---@field on_close? fun(): nil
---@field on_submit? fun(value: string): nil
*/
declare type NuiInputOptions = {
  prompt?: string | NuiText;
  default_value?: string;
  on_close?: (this: void) => void;
  on_submit?: (this: void, value: string) => void;
  on_change?: (this: void, value: string) => void;
  disable_cursor_position_patch?: boolean;
};

/*
---@class nui_input_internal: nui_popup_internal
---@field default_value string
---@field prompt NuiText
---@field disable_cursor_position_patch boolean
---@field on_change? fun(value: string): nil
---@field on_close fun(): nil
---@field on_submit fun(value: string): nil
---@field pending_submit_value? string
*/
declare interface NuiInputInternal extends NuiPopupInternal {
  default_value: string;
  prompt: NuiText;
  disable_cursor_position_patch: boolean;
  on_change?: (value: string) => void;
  on_close: () => void;
  on_submit: (value: string) => void;
  pending_submit_value?: string;
}

declare interface NuiInput extends NuiPopup {
  _: NuiInputInternal;

  mount(): void;

  unmount(): void;
}

