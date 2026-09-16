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
# Neovide (verified in neovide 0.13.2 … 0.16.2, same on main):
#   * embedded (plain `neovide`): setup_neovide_specific_state() sets
#     g:neovide and runs neovide's INIT_LUA BEFORE ui_attach (the call
#     site comment says "Triggers loading the user config"), so when
#     this chunk runs, g:neovide is already true. Embedded mode
#     registers no g:clipboard of its own
#     (register_clipboard = wsl || server.is_some()): leave g:clipboard
#     unset → nvim auto-detection (pbcopy etc.), plus
#     clipboard=unnamedplus for GUI-like yank/paste.
#   * `neovide --server` (nvim on a remote host): user config ran
#     already, g:neovide is nil here, so we select osc52/tmux —
#     harmless, because on attach neovide overwrites g:clipboard with
#     its RPC provider unconditionally (register_clipboard is true).
#     The UIEnter autocmd below then flips 'clipboard' to unnamedplus
#     for the same GUI behavior; UILeave restores everything when
#     neovide detaches (its RPC provider would be dead otherwise).
#
# Use extraConfigLuaPre so g:clipboard is set before the clipboard
# provider is first evaluated.
_: {
  extraConfigLuaPre = ''
    local function select_clipboard_provider()
      if vim.env.ET_VERSION ~= nil then
        -- Inside Eternal Terminal: always OSC 52, never xclip/xsel/tmux.
        vim.g.clipboard = "osc52"
      elseif vim.env.TMUX ~= nil then
        vim.g.clipboard = "tmux"
      else
        -- Local / plain SSH: keep OSC 52 as a remote-friendly default.
        vim.g.clipboard = "osc52"
      end
    end

    if vim.g.neovide then
      -- Neovide: keep nvim's auto-detected system provider (pbcopy
      -- ...) and sync yank/paste with the system clipboard by default.
      vim.opt.clipboard = "unnamedplus"
    else
      select_clipboard_provider()
    end

    -- `neovide --server` attaches long after this chunk ran, and
    -- g:neovide stays true even after it detaches, so identify the UI
    -- by its registered client name instead. neovide calls
    -- set_client_info("neovide") before ui_attach.
    local group = vim.api.nvim_create_augroup("dotvim_clipboard", { clear = true })
    local neovide_chan, saved_clipboard

    vim.api.nvim_create_autocmd("UIEnter", {
      group = group,
      callback = function()
        local chan = vim.v.event and vim.v.event.chan
        if type(chan) ~= "number" then
          return
        end
        local info = vim.api.nvim_get_chan_info(chan)
        if (info.client or {}).name ~= "neovide" then
          return
        end
        neovide_chan = chan
        saved_clipboard = vim.o.clipboard
        vim.opt.clipboard = "unnamedplus"
      end,
    })

    vim.api.nvim_create_autocmd("UILeave", {
      group = group,
      callback = function()
        local chan = vim.v.event and vim.v.event.chan
        if neovide_chan == nil or chan ~= neovide_chan then
          return
        end
        neovide_chan = nil
        vim.opt.clipboard = saved_clipboard or ""
        select_clipboard_provider()
      end,
    })
  '';
}
