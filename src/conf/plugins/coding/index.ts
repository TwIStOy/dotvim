import { plugin as commentNvim } from "./comment-nvim";
import { plugin as cphelper } from "./cphelper";
import { plugin as cppToolkit } from "./cpp-toolkit";
import { plugin as cratesNvim } from "./crates-nvim";
import { plugin as nabla } from "./nabla";
import { plugin as neogen } from "./neogen";
import { plugin as luasnip } from "./luasnip";
import { plugin as luasnipSnippets } from "./luasnip-snippets";

export const plugins = [
  commentNvim,
  cphelper,
  cppToolkit,
  cratesNvim,
  nabla,
  neogen,
  luasnip,
  luasnipSnippets,
] as const;
