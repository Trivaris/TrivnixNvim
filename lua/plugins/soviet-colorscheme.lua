return {
  "rezniqov/soviet.nvim",
  lazy = false,
  priority = 1000,
  opts = {}, -- Add your soviet.nvim settings here.
  config = function(_, opts)
    require("soviet").setup(opts)
    vim.cmd.colorscheme("soviet-dark")
    -- vim.cmd.colorscheme("soviet-light")
  end,
}