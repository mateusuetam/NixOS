-- neovim
vim.api.nvim_set_hl(0,"StatusLine",{bg="none"})
vim.api.nvim_set_hl(0,"StatusLineNC",{bg="none"})
vim.api.nvim_set_hl(0,'Comment',{bold=true,undercurl=true})

vim.opt.termguicolors=false
vim.opt.number=true
vim.opt.relativenumber=false
vim.opt.updatetime=250
vim.opt.inccommand="split"
vim.opt.colorcolumn="0"
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = false
vim.opt.list = true
vim.opt.listchars = {tab='  ',trail='•',nbsp='␣'}

-- netrw
vim.g.netrw_liststyle=3
vim.g.netrw_browse_split=2
vim.g.netrw_keepdir=0
vim.g.netrw_banner=0

-- remap
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>w', vim.cmd.w)
vim.keymap.set('n', '<leader>q', vim.cmd.q)
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>4', ':%left<CR>')
vim.keymap.set('n', '<leader>8', '<cmd>global/^$/delete<CR>')
vim.keymap.set('n', '<leader>6', 'mzgg=G`z')
vim.keymap.set('n', '<leader>1', ':%s/  \\+/ /g<CR>')
vim.keymap.set('n', '<leader>7', ':%s/\\s\\+$//e<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Telescope/Dashboard
local telescope_loaded = false
local dashboard_buf = nil
local dashboard_active = false
local dashboard_saved = nil
local dashboard_open
local dashboard_leave
local dashboard_render

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
"%.config/Code",
"%.config/dconf",
"%.config/discord",
"%.config/GIMP",
"%.config/jgit",
"%.config/mozilla",
"%.config/Proton",
"%.config/spotify",
"%.config/unity3d",
"%.copilot",
"%.icons",
"%.java",
"%.local",
"%.m2",
"%.mysql",
"%.netbeans",
"%.nix-defexpr",
"%.npm",
"%.pki",
"%.ssh",
"%.steam",
"%.vscode",
"%.vscode-shared",
"%.git/"
}
},

pickers = {
find_files = {
hidden = true,
},
}
})

telescope_loaded = true
end

local function telescope_select(action)
return function(prompt_bufnr)
action(prompt_bufnr)
dashboard_leave()
end
end

local function telescope_options()
local actions = require("telescope.actions")

return {
attach_mappings = function(prompt_bufnr, map)

map({ "i", "n" }, "<Esc>", function(bufnr)
actions.close(bufnr)
end)

map({ "i", "n" }, "<CR>", telescope_select(actions.select_default))
map({ "i", "n" }, "<C-x>", telescope_select(actions.select_horizontal))
map({ "i", "n" }, "<C-v>", telescope_select(actions.select_vertical))
map({ "i", "n" }, "<C-t>", telescope_select(actions.select_tab))

return true
end
}
end

function telescope_find_files()
telescope_setup()
require("telescope.builtin").find_files(telescope_options())
end

function telescope_oldfiles()
telescope_setup()
require("telescope.builtin").oldfiles(telescope_options())
end

vim.keymap.set("n", "<leader>f", telescope_find_files, {silent = true, desc = "Procurar arquivos"})

-- Dashboard
local dashboard_header = {
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠀⠀⢀⢐⠃⠀⠀⠀⠀⢀⢺⡡⠀⠀⠤⢄⣤⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⡀⢀⠀⠀⠀⠀⠀⠀⠀⠸⠀⡠⠀⠀⠀⠀⢨⠈⢿⡆⡀⠐⠘⠂⠔⡅⠀⠀⠀⠀⠠⠠⠄⡲⠀⠀⠀⠀⣀⠀⠀⠀]],
[[⢠⠀⠄⠀⠀⠀⠈⠄⡈⠀⠀⠀⠀⠀⠀⠀⠀⠂⢠⠐⡀⠀⠀⠀⠀⣸⡿⡀⢀⠐⢠⢲⠀⠀⠀⢀⢔⣂⣤⠀⠀⠀⠀⠀⢰⠃⠀⠀⠀]],
[[⠀⠪⠀⠀⠀⠀⠀⠃⠣⠥⣤⣬⣤⣀⢀⠀⠀⠆⠀⠇⢈⠤⢈⢀⠰⠿⢧⠅⠁⣠⠃⡇⠀⠀⠠⣡⣾⡋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠁⠀⠀⠀⠀⠀⠀⠈⠐⠠⢀⠁⠫⣷⡅⠄⣣⠤⠒⠊⠉⠉⠉⠉⠛⢷⣦⣤⣁⠸⠤⠀⠊⣤⣿⣯⠃⠀⠀⠀⠀⢾⠆⠀⠀⠀⠀⠀]],
[[⠀⠀⠴⠀⠀⢀⠠⠀⠀⢀⠀⠀⢀⠀⠋⡵⠊⠁⠀⠀⠀⠀⠀⠀⠀⠲⠀⠻⣿⣿⣷⣄⢶⣿⠿⣫⠂⠀⡀⠀⠈⠀⠈⠈⠄⠀⠈⣀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⡀⠐⠤⣀⡁⢠⠞⠀⢀⣀⣀⣀⠀⠀⢀⣠⠤⠤⢄⠀⢿⣷⣿⣿⣷⡑⢋⢃⣖⡩⠥⡡⠖⠁⠈⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢠⡀⢀⠃⠀⢊⠁⠀⠉⠉⢢⠐⣿⢃⣀⡀⠀⠀⠘⣿⣿⣿⣿⣷⠈⢏⡰⠖⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⡀⢀⣠⣤⣤⣤⣍⠈⠀⠠⠑⠒⠛⠋⠁⠈⠀⢻⡉⠉⠈⠁⠀⢀⣾⣝⣿⣿⣾⡇⠫⢄⡀⠀⠀⢀⡀⢀⣀⠦⣐⠀⠀⠀]],
[[⠀⠀⠤⠄⣊⣴⠟⠋⠉⠈⠉⠛⠀⢀⠁⠀⠀⠀⠀⠀⡀⠀⢀⡇⠀⠀⢠⣴⣼⣿⣿⣿⣿⣿⡇⣧⣆⣌⣡⣬⣶⡿⡻⠳⣔⠛⠀⠀⠀]],
[[⠀⠀⢂⠉⠉⠂⠁⠁⠀⠁⢐⠄⠠⠀⠉⠿⠂⠀⠀⠀⢉⣀⣈⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⠇⢽⣛⣛⣛⡻⠍⠊⠀⠀⠀⠀⠀⠀⠁]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢀⡠⠄⢃⠀⠄⠀⠀⠀⠈⠉⠭⠅⠉⠀⡠⢶⣿⣿⣿⣿⣿⣿⡟⢨⣂⡍⢣⢄⠀⠀⠀⠀⢠⡀⠀⣀⠀⠀]],
[[⠀⠂⠀⠀⠀⠀⠈⣐⠀⠁⠠⠤⡤⢀⠣⡀⠃⠀⠀⠀⠀⠀⣀⣤⣾⣷⣸⣿⣿⣿⣿⣿⠏⣤⠥⠮⣍⣓⣺⢅⠦⣀⠀⠀⠀⠃⠃⠀⡀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢊⣴⣿⠷⠌⠳⢴⣶⣶⣾⣟⣟⡿⣿⣿⣿⣿⢿⣿⠟⣥⡔⠼⡀⠀⠀⠀⠀⠈⠁⠉⡁⢀⡀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢱⣿⠟⢀⠠⠐⢀⠂⠈⠙⠙⠮⠿⠏⠿⠿⠟⠹⡉⠴⣞⢿⣿⣜⠝⣄⡀⠀⠀⠀⠀⠀⢕⣫⠀⠀⠈⠄⠁]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣿⡏⠔⠀⠀⠀⢈⠀⡸⠁⣀⢸⣿⠏⠀⠎⢊⢀⢹⡆⡟⠒⢍⡻⢿⣶⣯⣷⣤⠈⠀⠁⡯⡀⠀⢀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠠⢁⡛⠌⠀⠀⠀⠀⡆⠰⢡⠎⢰⢸⣿⠀⣼⠀⠀⠡⡔⢳⣹⠀⠀⠈⠁⠒⠙⠺⣽⡇⠀⠀⠈⡷⠸⠊⠃⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠈⠀⠁⠀⠀⠀⠀⠀⢀⠀⡑⠁⠀⠈⡘⣿⡌⢣⠀⠀⠀⠑⢌⠻⡄⠀⠀⠀⠀⠀⠀⠙⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⠀⠀⠈⠄⠀⠀⠀⠀⠐⠈⢿⣞⡆⠀⠀⠀⠈⢣⡧⠂⠀⠀⠀⠀⠀⠀⠀⠀⠨⠴⢦⢀⠀⠀⠀⠀]],
[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⡟⡧⠄⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⡀⠀⢤⡁⣮⡘⠀⠉⠀⠀⠀⠀]]
}

local dashboard_buttons = {
{
key = "n",
label = " Novo",
action = function()
dashboard_leave()
vim.cmd("enew")
vim.cmd("startinsert")
end
},

{
key = "f",
label = "󰱽 Procurar",
action = function()
telescope_find_files()
end
},

{
key = "r",
label = " Recentes",
action = function()
telescope_oldfiles()
end
},

{
key = "e",
label = "󰙅 Explorar",
action = function()
dashboard_saved.list = false
dashboard_leave()
vim.cmd("Ex")
end
},

{
key = "q",
label = "󰅚 Sair",
action = function()
vim.cmd("qa")
end
}
}

vim.api.nvim_set_hl(0, "DashboardCursor", {blend = 100})

local function dashboard_save_state()
if dashboard_saved then
return
end

dashboard_saved = {
laststatus = vim.o.laststatus,
showtabline = vim.o.showtabline,
showmode = vim.o.showmode,
guicursor = vim.o.guicursor,
number = vim.wo.number,
relativenumber = vim.wo.relativenumber,
cursorline = vim.wo.cursorline,
cursorcolumn = vim.wo.cursorcolumn,
signcolumn = vim.wo.signcolumn,
foldcolumn = vim.wo.foldcolumn,
colorcolumn = vim.wo.colorcolumn,
list = vim.wo.list,
wrap = vim.wo.wrap,
winbar = vim.wo.winbar,
statuscolumn = vim.wo.statuscolumn,
fillchars = vim.wo.fillchars,
scrolloff = vim.wo.scrolloff,
sidescrolloff = vim.wo.sidescrolloff
}
end

local function dashboard_setup_window()
vim.opt.laststatus = 0
vim.opt.showtabline = 0
vim.opt.showmode = false
vim.opt.guicursor = "a:DashboardCursor"

vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.cursorline = false
vim.wo.cursorcolumn = false
vim.wo.signcolumn = "no"
vim.wo.foldcolumn = "0"
vim.wo.colorcolumn = ""
vim.wo.list = false
vim.wo.wrap = false
vim.wo.winbar = ""
vim.wo.statuscolumn = ""
vim.wo.fillchars = "eob: "
vim.wo.scrolloff = 0
vim.wo.sidescrolloff = 0
end

dashboard_render = function()
if not dashboard_active then
return
end

if not dashboard_buf
or not vim.api.nvim_buf_is_valid(dashboard_buf)
then
return
end

local win = vim.api.nvim_get_current_win()

if not vim.api.nvim_win_is_valid(win) then
return
end

if vim.api.nvim_win_get_buf(win) ~= dashboard_buf then
return
end

local width = vim.api.nvim_win_get_width(win)
local height = vim.api.nvim_win_get_height(win)
local content = {}

for _, line in ipairs(dashboard_header) do
table.insert(content, line)
end

table.insert(content, "")
table.insert(content, "")

for _, button in ipairs(dashboard_buttons) do
table.insert(content, string.format("[%s] %s", button.key, button.label))
end

table.insert(content, "")
table.insert(content, "<Space>e Dashboard")

local top_padding = math.max(0, math.floor((height - #content) / 2))
local lines = {}

for _ = 1, top_padding do
table.insert(lines, "")
end

for _, line in ipairs(content) do
local line_width = vim.fn.strdisplaywidth(line)
local left_padding = math.max(0, math.floor((width - line_width) / 2))

table.insert(lines, string.rep(" ", left_padding) .. line)
end

vim.bo[dashboard_buf].modifiable = true
vim.api.nvim_buf_set_lines(dashboard_buf, 0, -1, false, lines)
vim.bo[dashboard_buf].modifiable = false

local cursor_row = math.max(1, math.min(top_padding + 1, math.max(1, #lines)))

pcall(vim.api.nvim_win_set_cursor, win, {cursor_row, 0})
end

local function dashboard_create()
dashboard_buf = vim.api.nvim_create_buf(false, true)

vim.bo[dashboard_buf].buftype = "nofile"
vim.bo[dashboard_buf].bufhidden = "hide"
vim.bo[dashboard_buf].swapfile = false
vim.bo[dashboard_buf].modifiable = false
vim.bo[dashboard_buf].filetype = "dashboard"

return dashboard_buf
end

dashboard_open = function()
if not dashboard_buf
or not vim.api.nvim_buf_is_valid(dashboard_buf)
then
dashboard_create()
end

if not dashboard_active then
dashboard_save_state()
end

if vim.api.nvim_get_current_buf() ~= dashboard_buf then
vim.api.nvim_set_current_buf(dashboard_buf)
end

dashboard_active = true

dashboard_setup_window()

for _, button in ipairs(dashboard_buttons) do
vim.keymap.set("n", button.key, button.action,
{
buffer = dashboard_buf,
silent = true,
desc = button.label
})
end

dashboard_render()
end

dashboard_leave = function()
if not dashboard_active then
return
end

dashboard_active = false

if not dashboard_saved then
return
end

vim.opt.laststatus = dashboard_saved.laststatus
vim.opt.showtabline = dashboard_saved.showtabline
vim.opt.showmode = dashboard_saved.showmode
vim.opt.guicursor = dashboard_saved.guicursor

vim.wo.number = dashboard_saved.number
vim.wo.relativenumber = dashboard_saved.relativenumber
vim.wo.cursorline = dashboard_saved.cursorline
vim.wo.cursorcolumn = dashboard_saved.cursorcolumn
vim.wo.signcolumn = dashboard_saved.signcolumn
vim.wo.foldcolumn = dashboard_saved.foldcolumn
vim.wo.colorcolumn = dashboard_saved.colorcolumn
vim.wo.list = dashboard_saved.list
vim.wo.wrap = dashboard_saved.wrap
vim.wo.winbar = dashboard_saved.winbar
vim.wo.statuscolumn = dashboard_saved.statuscolumn
vim.wo.fillchars = dashboard_saved.fillchars
vim.wo.scrolloff = dashboard_saved.scrolloff
vim.wo.sidescrolloff = dashboard_saved.sidescrolloff

dashboard_saved = nil

vim.cmd("redrawstatus")
end

vim.keymap.set("n", "<leader>e", dashboard_open,
{
silent = true,
desc = "Abrir dashboard"
})

local dashboard_group = vim.api.nvim_create_augroup("Dashboard", {clear = true})

vim.api.nvim_create_autocmd("VimResized",
{
group = dashboard_group,
callback = function()
if dashboard_active then
vim.schedule(dashboard_render)
end
end
})

if vim.fn.argc() == 0 then
dashboard_open()
end
