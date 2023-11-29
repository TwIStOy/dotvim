import { ifNil } from "@core/vim";

export interface SnippetSpec {
  name?: string;
  dscr?: string;
  mode?: string;
}

export function buildSnippet(trig: string, opts: SnippetSpec) {
  let name = ifNil(opts.name, trig);
  let dscr = ifNil(opts.dscr, `Snippet: ${name}`);
  let mode = ifNil(opts.mode, "");
}
