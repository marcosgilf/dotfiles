-- Neo-tree file explorer, following Kickstart's optional plugin module.
vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- Use a letter-based leader mapping for Spanish ISO layouts.
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'Open file explorer' })

require('neo-tree').setup {
  window = {
    mappings = {
      ['?'] = 'noop',
      ['#'] = 'noop',
      ['<'] = 'noop',
      ['>'] = 'noop',
      gh = 'show_help',
      gs = 'fuzzy_sorter',
      gP = 'prev_source',
      gN = 'next_source',
    },
  },
  filesystem = {
    window = {
      mappings = {
        ['/'] = 'noop',
        ['[g'] = 'noop',
        [']g'] = 'noop',
        ['.'] = 'noop',
        gf = 'fuzzy_finder',
        gp = 'prev_git_modified',
        gn = 'next_git_modified',
        gr = 'set_root',
      },
    },
  },
}
