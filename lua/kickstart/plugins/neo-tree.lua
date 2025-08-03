-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    -- { '\\g', ':Neotree focus git_status right<CR>', desc = 'NeoTree Git status', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        width = 40,
        mappings = {
          ['\\'] = 'close_window',
          ['P'] = { 'toggle_preview', config = {
            title = 'File Preview',
          } },
          ['<C-f>'] = { 'scroll_preview', config = { direction = -5 } },
          ['<C-b>'] = { 'scroll_preview', config = { direction = 5 } },
        },
      },
    },

    source_selector = {
      -- winbar = true,
      statusline = false,

      sources = {
        { source = 'filesystem' },
        { source = 'git_status' },
      },
    },
  },
}
