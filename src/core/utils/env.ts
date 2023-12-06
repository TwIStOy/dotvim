function envHas(key: string): Promise<boolean> {
  return new Promise<boolean>((resolve) => {
    vim.schedule(() => {
      resolve(vim.env.has(key));
    });
  });
}

export function inTmux(): Promise<boolean> {
  return envHas("TMUX");
}

export async function inSSH(): Promise<boolean> {
  return (await envHas("SSH_CLIENT")) || (await envHas("SSH_TTY"));
}
