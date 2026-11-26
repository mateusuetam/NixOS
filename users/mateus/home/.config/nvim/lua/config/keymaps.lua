local M = {}

function M.setup(deps)
local telescope = deps.telescope
local dashboard = deps.dashboard

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>q", vim.cmd.q)

vim.keymap.set({"n", "v"}, "<leader>y", '"+y')
vim.keymap.set({"n", "v"}, "<leader>p", '"+p')

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>4", ":%left<CR>")
vim.keymap.set("n", "<leader>8", "<cmd>global/^$/delete<CR>")
vim.keymap.set("n", "<leader>6", "mzgg=G`z")
vim.keymap.set("n", "<leader>1", ":%s/  \\+/ /g<CR>")
vim.keymap.set("n", "<leader>7", ":%s/\\s\\+$//e<CR>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>f", telescope.find_files, {silent = true, desc = "Procurar arquivos"})

vim.keymap.set("n", "<leader>e", dashboard.open, {silent = true, desc = "Abrir dashboard"})
end

return M
