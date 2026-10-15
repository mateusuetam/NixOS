local M = {}

function M.setup()
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.updatetime = 250
vim.opt.inccommand = "split"
vim.opt.colorcolumn = "0"

vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false

vim.opt.list = true
vim.opt.listchars = {tab = "  ", trail = "•", nbsp = "␣"}

vim.opt.termguicolors = false

vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 2
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
end

return M
