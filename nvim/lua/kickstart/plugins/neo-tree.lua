-- Neo-tree file explorer, following Kickstart's optional plugin module.
vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

-- Use a letter-based leader mapping for Spanish ISO layouts.
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'Open file explorer' })

require('neo-tree').setup {}
