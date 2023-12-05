export function inTmux(): boolean {
  return vim.env.has("TMUX");
}

export function inSSH(): boolean {
  return vim.env.has("SSH_CLIENT") || vim.env.has("SSH_TTY");
}
