return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>",           desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>",            desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>",              desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>",            desc = "Help" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>",             desc = "Recent" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>",          desc = "Diagnostics" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local ignore = {
			"%.ttf", "%.otf", "%.woff", "%.woff2", "%.eot",
			"%.png", "%.jpg", "%.jpeg", "%.gif", "%.webp", "%.svg", "%.ico", "%.bmp",
			"%.mp4", "%.mov", "%.avi", "%.mp3", "%.wav", "%.flac",
			"%.ini", "%.lock", "%.sum",
			"%.pdf", "%.zip", "%.tar", "%.gz", "%.7z", "%.exe", "%.dll", "%.so",
			"%.dylib", "%.class", "%.pyc",
			"node_modules/", "%.git/", "target/", "dist/", "build/", "__pycache__/",
		}

		telescope.setup({
			defaults = {
				file_ignore_patterns = ignore,
				prompt_prefix = " 󰭎 ",
				selection_caret = " 󱞩 ",
				path_display = { "truncate" },
				sorting_strategy = "descending",
				layout_config = {
					horizontal = { prompt_position = "bottom", preview_width = 0 },
					width = 0.30,
					height = 0.50,
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<esc>"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = { hidden = false },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		telescope.load_extension("fzf")
	end,
}
