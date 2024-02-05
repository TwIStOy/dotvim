import { VimBuffer, system } from "@core/vim";

export async function inGitRepo(buffer?: VimBuffer): Promise<boolean> {
  let cwd: string | undefined;
  if (buffer && buffer.fullFileName) {
    cwd = vim.fn.fnamemodify(buffer.fullFileName, ":h");
  }
  let ret = await system(["git", "rev-parse", "--is-inside-work-tree"], {
    cwd,
  });
  return ret.code === 0;
}

export async function getCurrentRepoPath(
  buffer?: VimBuffer
): Promise<string | null> {
  let cwd: string | undefined;
  if (buffer && buffer.fullFileName) {
    cwd = vim.fn.fnamemodify(buffer.fullFileName, ":h");
  }
  let ret = await system(["git", "rev-parse", "--show-toplevel"], {
    cwd,
  });
  if (ret.code !== 0) {
    return null;
  }
  return ret.stdout!.trim();
}

export function readFileSync(filename: string): string | undefined {
  let [file] = io.open(filename, "r");
  if (!file) {
    return undefined;
  }
  let content = file!.read("*a");
  file.close();
  return content;
}
