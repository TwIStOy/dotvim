import { plugin as conform } from "./conform";
import { plugin as copilot } from "./copilot";
import { plugin as markdownPreviewNivm } from "./markdown-preview-nivm";
import { plugin as vimTemplate } from "./vim-template";
import { plugin as todoCommentsNvim } from "./todo-comments-nvim";
import { plugin as ultimateAutopairNvim } from "./ultimate-autopair-nvim";
import { plugin as taboutNvim } from "./tabout-nvim";
import { plugin as dial } from "./dial";

export const plugins = [
  conform,
  copilot,
  markdownPreviewNivm,
  vimTemplate,
  todoCommentsNvim,
  ultimateAutopairNvim,
  taboutNvim,
  dial,
] as const;
