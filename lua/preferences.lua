-- Define default settings
local default_preferences = {
    colorscheme = "default",
    use_lsp = false
}

local user_preferences = {}
if vim.env.USER_PREFERENCES then
    user_preferences = dofile(vim.env.USER_PREFERENCES)
end

return vim.tbl_deep_extend("force", default_preferences, user_preferences)