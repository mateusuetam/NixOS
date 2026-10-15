local M = {}

function M.setup()
vim.api.nvim_set_hl(0, "StatusLine", {bg = "none"})
vim.api.nvim_set_hl(0, "StatusLineNC", {bg = "none"})
vim.api.nvim_set_hl(0, "Comment", {bold = true, undercurl = true})
end

return M
