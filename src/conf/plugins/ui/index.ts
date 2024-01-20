import { plugin as twilight } from "./twilight";
import { plugin as colorfulWinsepNvim } from "./colorful-winsep-nvim";
import { plugin as headlinesNvim } from "./headlines-nvim";
import { plugin as nvimWindowPicker } from "./nvim-window-picker";
import { plugin as dressingNvim } from "./dressing-nvim";
import { plugin as bufferline } from "./bufferline";
import { plugin as noice } from "./noice";
import { plugin as nvimNotify } from "./nvim-notify";
import { plugin as lualine } from "./lualine";
import { plugin as nvimColorizer } from "./nvim-colorizer";
import { plugin as nvimScrollview } from "./nvim-scrollview";
import { plugin as neoTreeNvim } from "./neo-tree-nvim";
import { plugin as dropNvim } from "./drop-nvim";
import { plugin as extWidget } from "./ext-widget";
import { plugin as dropbar } from "./dropbar";

export const plugins = [
  twilight,
  colorfulWinsepNvim,
  headlinesNvim,
  nvimWindowPicker,
  dressingNvim,
  bufferline,
  nvimNotify,
  noice,
  lualine,
  nvimColorizer,
  nvimScrollview,
  neoTreeNvim,
  dropNvim,
  extWidget,
  // dropbar,
] as const;
