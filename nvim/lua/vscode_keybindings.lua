-- VSCode Neovim extension keybindings
-- These call VSCode commands via the extension's API
local vscode = require('vscode')

-- File navigation
vim.keymap.set('n', '<leader>ff', function() vscode.action('workbench.action.quickOpen') end)
vim.keymap.set('n', '<leader>fg', function() vscode.action('workbench.action.findInFiles') end)
vim.keymap.set('n', '<leader>fb', function() vscode.action('workbench.action.showAllEditorsByMostRecentlyUsed') end)

-- Sidebar toggle (replaces NERDTree)
vim.keymap.set('n', '<leader>n', function() vscode.action('workbench.action.toggleSidebarVisibility') end)
vim.keymap.set('n', '<leader>N', function() vscode.action('workbench.files.action.showActiveFileInExplorer') end)

-- Editor splits
vim.keymap.set('n', '<C-H>', function() vscode.action('workbench.action.focusLeftGroup') end)
vim.keymap.set('n', '<C-L>', function() vscode.action('workbench.action.focusRightGroup') end)
vim.keymap.set('n', '<C-J>', function() vscode.action('workbench.action.focusBelowGroup') end)
vim.keymap.set('n', '<C-K>', function() vscode.action('workbench.action.focusAboveGroup') end)

-- Code actions
vim.keymap.set('n', '<leader>ca', function() vscode.action('editor.action.quickFix') end)
vim.keymap.set('n', 'gd', function() vscode.action('editor.action.revealDefinition') end)
vim.keymap.set('n', 'gr', function() vscode.action('editor.action.goToReferences') end)
vim.keymap.set('n', 'K', function() vscode.action('editor.action.showHover') end)
