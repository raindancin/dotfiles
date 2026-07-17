return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					-- theme = "auto",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
					lualine_b = { "filename" },
					lualine_c = { "" },
					lualine_x = { "" },
					lualine_y = { "location", "progress" },
					lualine_z = { "" },
				},
			})
			-- vim.cmd.hi("lualine_c_normal guibg=bg")
			-- vim.cmd.hi("lualine_c_insert guibg=bg")
			-- vim.cmd.hi("lualine_c_visual guibg=bg")
			-- vim.cmd.hi("lualine_c_command guibg=bg")
			-- vim.cmd.hi("lualine_a_normal guifg=#000000")
			-- vim.cmd.hi("lualine_a_normal guibg=#56a8f5")
			-- vim.cmd.hi("lualine_a_insert guibg=#6aab73")
			-- vim.cmd.hi("lualine_a_visual guibg=#c77dbb")
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			fast_wrap = false,
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({})

			-- CMP integration
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				markdown = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 300,
				lsp_fallback = true,
			},
		},
	},
}
