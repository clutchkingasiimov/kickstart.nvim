-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- { 'mfussenegger/nvim-dap' }, --Debugger plugin
  { 'Bekaboo/deadcolumn.nvim' }, --Shows deadline to manage code length
  -- { 'mrjones2014/smart-splits.nvim' } Used for smart splitting when using Wezterm
  -- { 'rcarriga/nvim-dap-ui' }, --UI for DAP debugger plugin

  -- Markdown and TeX viewer
  { 'OXY2DEV/markview.nvim', lazy = false },

  {
    'akinsho/toggleterm.nvim',
    config = true,
    keys = {
      { '<leader>bn', '<cmd>TermNew<cr>', desc = 'Create [N]ew Terminal' },
    },
    opts = {
      -- open_mapping = [[<c-\>]],
      shell = vim.o.shell,
      direction = 'vertical',
      size = 60,
    },
  },

  --Session persistence & management
  { 'rmagatti/auto-session' },
  -- { 'NeogitOrg/neogit' }, -- Visually rich experience of Git inside Nvim

  --Statusline for nvim
  {
    'nvim-lualine/lualine.nvim',
    dependncies = { 'nvim-tree/nvim-web-devicons', opt = true },
    -- config = function()
    --   require('lualine').setup()
    -- end,

    opts = {
      theme = 'gruvbox',
    },
    sections = {
      lualine_x = { 'fileformat', 'filetype' },
    },
    inactive_sections = {
      lualine_c = { 'filename' },
    },
  },

  --Breadcrumb plugin for easier access
  {
    'Bekaboo/dropbar.nvim',
    --Parameters for the plugin
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    random_dictionary = {},
    config = function()
      --Keymaps for Dropbar
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to the start of the current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
  },
}
