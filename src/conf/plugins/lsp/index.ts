import { plugin as mason } from "./mason";
import { plugin as aerial } from "./aerial";
import { plugin as typescriptToolsNvim } from "./typescript-tools-nvim";

export const plugins = [mason, aerial, typescriptToolsNvim] as const;
