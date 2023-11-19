import asyncTask from "./asynctask";
import tmuxline from "./tmuxline";
import closeBuffers from "./close-buffers";
import dashNvim from "./dash-nvim";
import gitsignsNvim from "./gitsigns-nvim";
import octoNvim from "./octo-nvim";
import restNvim from "./rest-nvim";
import ghActionNvim from "./gh-action-nvim";

export default [
  asyncTask,
  tmuxline,
  closeBuffers,
  dashNvim,
  gitsignsNvim,
  octoNvim,
  restNvim,
  ghActionNvim,
];
