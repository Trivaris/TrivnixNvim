local user_preferences = require("user_overrides")

-- Define default settings
local default_preferences = {
    colorscheme = "default",
    use_lsp = false
}

return vim.tbl_deep_extend("force", default_preferences, user_preferences)