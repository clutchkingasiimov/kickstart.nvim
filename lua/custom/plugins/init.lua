-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- { 'mfussenegger/nvim-dap' }, --Debugger plugin
  { 'EdenEast/nightfox.nvim' }, --Nightfox theme plugin
  { 'folke/persistence.nvim', event = 'BufReadPre' }, --Session persistence & management
  -- { 'NeogitOrg/neogit' }, -- Visually rich experience of Git inside Nvim
  --Harpoon2 plugin (Fast file navigation)
  -- {
  --   'ThePrimeagen/harpoon',
  --   branch = 'harpoon2',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     local harpoon = require 'harpoon'
  --
  --     --Needs this function call to riue
  --     harpoon:setup()
  --     -----
  --     vim.keymap.set('n', '<leader>a', function()
  --       harpoon:list():add()
  --     end, { desc = 'Harpoon [a]dd' })custom
  --     vim.keymap.set('n', '1', function()
  --       harpoon:list():select(1)
  --     end)
  --     vim.keymap.set('n', '2', function()
  --       harpoon:list():select(2)
  --     end)
  --     vim.keymap.set('n', '3', function()
  --       harpoon:list():select(3)
  --     end)
  --     vim.keymap.set('n', '4', function()
  --       harpoon:list():select(4)
  --     end)
  --   end,
  -- },
  --Statusline for nvim
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
          section_separators = {},
        },
        sections = {
          lualine_b = { 'branch', 'diff' },
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
          lualine_c = { 'filename' },
        },
      }
    end,
  },

  -- {
  --   'Bekaboo/dropbar.nvim',
  --   -- Parameters for the plugin
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim',
  --     build = 'make',
  --   },
  --   random_dictionary = {},
  --   config = function()
  --     --Keymaps for Dropbar
  --     local dropbar_api = require 'dropbar.api'
  --     vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
  --     vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to the start of the current context' })
  --     vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
  --   end,
  -- },
}
