-- multicursor.nvim: multiple cursors (branch 1.0)
-- Adapted keymaps: <leader>s is the search group and <leader>c is the code
-- group in this config, so match-skip actions live under <leader>m
-- ([M]ulticursor) instead.
vim.pack.add { { src = 'https://github.com/jake-stewart/multicursor.nvim', branch = '1.0' } }

local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

-- Add / skip a cursor on the line above or below.
set({ 'n', 'x' }, '<up>', function() mc.lineAddCursor(-1) end, { desc = 'MC: Add Cursor Up' })
set({ 'n', 'x' }, '<down>', function() mc.lineAddCursor(1) end, { desc = 'MC: Add Cursor Down' })
set({ 'n', 'x' }, '<leader><up>', function() mc.lineSkipCursor(-1) end, { desc = 'MC: Skip Cursor Up' })
set({ 'n', 'x' }, '<leader><down>', function() mc.lineSkipCursor(1) end, { desc = 'MC: Skip Cursor Down' })

-- Add / skip a cursor on the next/previous match of the word under the cursor.
set({ 'n', 'x' }, '<leader>n', function() mc.matchAddCursor(1) end, { desc = 'MC: Add Next Match' })
set({ 'n', 'x' }, '<leader>N', function() mc.matchAddCursor(-1) end, { desc = 'MC: Add Prev Match' })
set({ 'n', 'x' }, '<leader>mn', function() mc.matchSkipCursor(1) end, { desc = 'MC: Skip Next Match' })
set({ 'n', 'x' }, '<leader>mN', function() mc.matchSkipCursor(-1) end, { desc = 'MC: Skip Prev Match' })

-- Add a cursor to every match of the word under the cursor in the buffer.
set({ 'n', 'x' }, '<leader>ma', mc.matchAllAddCursors, { desc = 'MC: Add All Matches' })

-- Add cursors to every match and drop straight into change-word mode so you
-- can type the replacement once and apply it everywhere. matchAllAddCursors
-- places each cursor at the start of the matched word, so `cw` replaces it.
set('n', '<leader>mR', function()
  mc.matchAllAddCursors()
  mc.feedkeys 'cw'
end, { desc = 'MC: Add All & Replace Word' })

-- Add a cursor to every match of the LAST search (/ register). Unlike
-- matchAllAddCursors this matches anything you searched for, including parts
-- of a word (e.g. "foo" inside "foobar"). Flow: /pattern<cr> -> <leader>m/
-- -> cw -> type replacement -> <esc>.
set('n', '<leader>m/', mc.searchAllAddCursors, { desc = 'MC: Add All Search Matches' })

-- Restore cursors you accidentally cleared.
set('n', '<leader>mr', mc.restoreCursors, { desc = 'MC: Restore Cursors' })

-- Add/remove cursors with the mouse.
set('n', '<c-leftmouse>', mc.handleMouse)
set('n', '<c-leftdrag>', mc.handleMouseDrag)
set('n', '<c-leftrelease>', mc.handleMouseRelease)

-- Disable/enable all cursors (only the main cursor moves while disabled).
set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'MC: Toggle Cursors' })

-- Keymap layer: these mappings only apply WHILE multiple cursors are active.
mc.addKeymapLayer(function(layerSet)
  -- Rotate which cursor is the main one.
  layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
  layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

  -- <esc> clears cursors (falls back to the normal <esc> when only one cursor).
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- Cursor highlight groups.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })

-- Register the <leader>m group in which-key.
local ok, wk = pcall(require, 'which-key')
if ok then wk.add { { '<leader>m', group = '[M]ulticursor', mode = { 'n', 'x' } } } end
