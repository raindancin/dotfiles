vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Yank text to system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.showmode = false

-- Add border for cmp & more
vim.opt.winborder = "rounded"

-- Remove annoying startup message
vim.opt.shortmess:append("I")

-- Remove tildas on the left of line number
vim.opt.fillchars:append("eob: ")

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Completion
-- vim.opt.autocomplete = true
-- vim.opt.completeopt = "fuzzy,menu,menuone,popup"
vim.opt.pumheight = 10

-- Files
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.undofile = false
vim.opt.backup = false
vim.opt.swapfile = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Highlighting stuff
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = "/,?",
	callback = function()
		vim.o.hlsearch = true
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = "/,?",
	callback = function()
		vim.schedule(function()
			vim.o.hlsearch = false
		end)
	end,
})

-- Keymaps
vim.keymap.set({ "n", "v" }, "mm", "%", { desc = "Go to matching brace" })
