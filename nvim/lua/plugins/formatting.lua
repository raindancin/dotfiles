return {
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
}
