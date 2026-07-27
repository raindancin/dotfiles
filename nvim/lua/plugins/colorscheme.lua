return {
	{
		"raindancin/jetbrains_dark",
		lazy = false,
	},
	{
		"raindancin/solarized",
		lazy = false,
		priority = 1000,
		config = function()
			require("solarized").setup({
  			transparent = false,      -- set true to use your terminal's own background
  			terminal_colors = true,   -- sync :terminal ANSI colors to this palette
  			style = "auto",           -- "auto" | "dark" | "light" -- see Dark / light below

  			styles = {
    			comments = { italic = true },
    			keywords = { italic = false },
    			functions = {},
    			variables = {},
  			},

  			integrations = {
    			treesitter = true,
    			lsp = true,
    			telescope = true,
    			cmp = true,
    			lualine = true,
    			leap = true,
    			mason = true,
    			gitsigns = true,
    			which_key = true,
    			indent_blankline = false,
    			render_markdown = true,
    			oil = false,
    			lazy = true,
  		},
		})
			vim.cmd.colorscheme("solarized")
		end
	}
}
