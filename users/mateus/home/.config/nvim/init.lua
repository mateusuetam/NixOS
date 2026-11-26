local options = require("config.options")
local theme = require("config.theme")
local keymaps = require("config.keymaps")

local telescope = require("features.telescope")
local dashboard = require("features.dashboard")

options.setup()
theme.setup()

telescope.setup({dashboard_leave = dashboard.leave})

dashboard.setup({telescope = telescope})

keymaps.setup({telescope = telescope, dashboard = dashboard})

if vim.fn.argc() == 0 then
dashboard.open()
end
