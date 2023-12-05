import { plugin as conform } from "./conform";
import { plugin as copilot } from "./copilot";
import { plugin as markdownPreviewNivm } from "./markdown-preview-nivm";
import { plugin as vimTemplate } from "./vim-template";
import { plugin as todoCommentsNvim } from "./todo-comments-nvim";
import { plugin as ultimateAutopairNvim } from "./ultimate-autopair-nvim";
import { plugin as taboutNvim } from "./tabout-nvim";
import { plugin as dial } from "./dial";
import { plugin as bookmarkNvim } from "./bookmark-nvim";
import { plugin as vimTableMode } from "./vim-table-mode";
import { plugin as miniMove } from "./mini-move";

export const plugins = [
  conform,
  copilot,
  markdownPreviewNivm,
  vimTemplate,
  todoCommentsNvim,
  ultimateAutopairNvim,
  taboutNvim,
  dial,
  bookmarkNvim,
  vimTableMode,
  miniMove,
] as const;
