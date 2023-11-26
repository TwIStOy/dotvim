import { plugin as mason } from "./mason";
import { plugin as aerial } from "./aerial";
import { plugin as glanceNvim } from "./glance-nvim";
import { plugin as lspkindNvim } from "./lspkind-nvim";
import { plugin as troubleNvim } from "./trouble-nvim";

export const plugins = [
  mason,
  aerial,
  glanceNvim,
  lspkindNvim,
  troubleNvim,
] as const;
