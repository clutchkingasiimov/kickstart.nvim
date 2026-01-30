return {

  {
    'EdenEast/nightfox.nvim', --Nightfox theme plugin
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nightfox').setup {
        dim_inactive = true,
        styles = {
          comments = 'italic',
          keywords = 'bold',
          types = 'bold',
        },
        palettes = {
          carbonfox = {
            bg1 = '#000000', -- Default background
            inactive = '#090909',
          },
        },
      }
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'nightfox'
      -- vim.o.background = 'dark'
    end,
  },
}
