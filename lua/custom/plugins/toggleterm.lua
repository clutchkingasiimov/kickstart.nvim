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
        autochdir = true,
        shade_terminals = true,
        shading_factor = 5,
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
      local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, display_name = 'Lazygit', direction = 'float', float_opts = { border = 'double' } }

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      -- Keeps the above keymaps for ToggleTerm only
      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
    end,
  },
}
