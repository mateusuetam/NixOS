local M = {}

local telescope_loaded = false
local dashboard_leave = function()
end

local function telescope_setup()
if telescope_loaded then
return
end

vim.cmd("packadd plenary.nvim")
vim.cmd("packadd telescope.nvim")

require("telescope").setup({
defaults = {
file_ignore_patterns = {
"%.cache",
"%.config/dconf",
"%.config/discord",
"%.config/GIMP",
"%.config/mozilla",
"%.config/nautilus",
"%.config/pulse",
"%.config/spotify",
"%.icons",
"%.local",
"%.nix-defexpr",
"%.pki",
"%.ssh",
"%.steam",
"%.git/"
}
},

pickers = {
find_files = {hidden = true}
}
})

telescope_loaded = true
end

local function telescope_select(action)
return function(prompt_bufnr)
dashboard_leave()
action(prompt_bufnr)
end
end

local function telescope_options()
local actions = require("telescope.actions")

return {
attach_mappings = function(prompt_bufnr, map)
map({ "i", "n" }, "<Esc>", function(bufnr) actions.close(bufnr) end)
map({ "i", "n" }, "<CR>", telescope_select(actions.select_default))
map({ "i", "n" }, "<C-x>", telescope_select(actions.select_horizontal))
map({ "i", "n" }, "<C-v>", telescope_select(actions.select_vertical))
map({ "i", "n" }, "<C-t>", telescope_select(actions.select_tab))
return true
end
}
end

function M.setup(opts)
opts = opts or {}
dashboard_leave = opts.dashboard_leave or function()
end
end

function M.find_files()
telescope_setup()
require("telescope.builtin").find_files(telescope_options())
end

function M.oldfiles()
telescope_setup()
require("telescope.builtin").oldfiles(telescope_options())
end

return M
