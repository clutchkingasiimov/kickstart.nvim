return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      local custom_powerline = require 'lualine.themes.powerline_dark'
      custom_powerline.inactive.c.fg = '#FF0000'
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = custom_powerline,
          -- section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = {
                readonly = '',
                unnamed = '[UNNAMED]',
                modified = '󱓩',
                newfile = '󰎔',
              },
            },
          },
          lualine_x = { 'fileformat', 'filetype' },
          lualine_y = { '' },
        },
        inactive_sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
            },
          },
        },
      }
    end,
  },
}
