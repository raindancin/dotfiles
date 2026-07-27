return {
	"williamboman/mason.nvim",
	md = "Mason",
	keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
	build = ":MasonUpdate",
	opts = {
		ui = {
			border = "rounded",
			icons = {
				package_installed = "󰗠",
				package_pending = "󱍷",
				package_uninstalled = "󰚃",
			},
		},
	},
}
