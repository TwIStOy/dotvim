# Clipboard provider selection for nixvim.
#
# Neovim picks the tool in provider#clipboard#Executable()
# (runtime/autoload/provider/clipboard.vim):
#   1. g:clipboard string name or dict → force that provider
#   2. else auto-detect, roughly:
#        mac pbcopy
#        → WAYLAND + wl-copy/wayclip
#        → $DISPLAY + xsel/xclip   ← wrong under Eternal Terminal
#        → lemonade / win32yank / ...
#        → $TMUX
#        → OSC 52 only as last resort (and only if g:termfeatures.osc52
#          is true AND 'clipboard' option is empty)
#
# Eternal Terminal sets ET_VERSION and often also forwards X11, so
# $DISPLAY is non-empty (e.g. localhost:10.0). Auto-detection then
# picks xclip/xsel, which talks to the *remote* X server instead of
# the local machine clipboard. OSC 52 goes through the terminal and
# reaches the ET client correctly, so force it whenever we are in ET
# (including ET + tmux).
#
# Use extraConfigLuaPre so g:clipboard is set before the clipboard
# provider is first evaluated.
_: {
  extraConfigLuaPre = ''
    if vim.env.ET_VERSION ~= nil then
      -- Inside Eternal Terminal: always OSC 52, never xclip/xsel/tmux.
      vim.g.clipboard = "osc52"
    elseif vim.env.TMUX ~= nil then
      vim.g.clipboard = "tmux"
    else
      -- Local / plain SSH: keep OSC 52 as a remote-friendly default.
      vim.g.clipboard = "osc52"
    end
  '';
}
