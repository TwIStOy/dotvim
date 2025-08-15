-- use OSC 52 as default
vim.g.clipboard = "osc52"

if vim.env.TMUX ~= nil then
  vim.g.clipboard = "tmux"
end
