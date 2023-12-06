function envHas(key: string): boolean {
  return vim.env.has(key);
}

export function inTmux() {
  return envHas("TMUX");
}

export function inSSH() {
  return envHas("SSH_CLIENT") || envHas("SSH_TTY");
}
