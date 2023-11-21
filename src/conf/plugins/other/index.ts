import { plugin as asyncTask } from "./asynctask";
import { plugin as tmuxline } from "./tmuxline";
import { plugin as closeBuffers } from "./close-buffers";
import { plugin as dashNvim } from "./dash-nvim";
import { plugin as gitsignsNvim } from "./gitsigns-nvim";
import { plugin as octoNvim } from "./octo-nvim";
import { plugin as restNvim } from "./rest-nvim";
import { plugin as ghActionNvim } from "./gh-action-nvim";

export const plugins = [
  asyncTask,
  tmuxline,
  closeBuffers,
  dashNvim,
  gitsignsNvim,
  octoNvim,
  restNvim,
  ghActionNvim,
];
