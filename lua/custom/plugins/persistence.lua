-- persistence.nvim: session save/restore (layout, panes, buffers)
vim.pack.add { 'https://github.com/folke/persistence.nvim' }
require('persistence').setup {
  dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'),
  options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
}

local map = vim.keymap.set
map('n', '<leader>qs', function() require('persistence').load() end, { desc = '[Q]uit [S]ession restore' })
map('n', '<leader>qS', function() require('persistence').select() end, { desc = '[Q]uit [S]ession select' })
map('n', '<leader>ql', function() require('persistence').load { last = true } end, { desc = 'Restore [L]ast session' })
map('n', '<leader>qd', function() require('persistence').stop() end, { desc = '[Q]uit without [D] session save' })
