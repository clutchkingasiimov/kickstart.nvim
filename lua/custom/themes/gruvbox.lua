return {
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        undercurl = true,
        underline = true,
        bold = true,
        inverse = true,
        dim_inactive = false,
        invert_selection = true,
      }
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
}
