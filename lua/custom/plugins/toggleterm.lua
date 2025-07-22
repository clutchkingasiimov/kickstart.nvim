return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    lazy = false,
    cmd = { 'ToggleTerm' },
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<c-\>]],
        on_create = function(t)
          -- Add your on_create logic here
        end,
        on_open = function(t)
          -- Add your on_open logic here
        end,
        hide_numbers = true,
        autochdir = false,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal',
        shell = vim.o.shell,
        winbar = {
          enabled = false,
          name_formatter = function(term)
            return term.name
          end,
        },
      }
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, display_name = 'Lazygit' }

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
    end,
  },
}
