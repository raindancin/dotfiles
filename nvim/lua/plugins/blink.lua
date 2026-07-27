return {
	"saghen/blink.cmp",
	-- pinned to the stable v1 branch on purpose: v2 is under active development
	-- with breaking changes, upgrade deliberately when ready, not automatically
	version = "1.*",
	event = "InsertEnter",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			-- "enter" preset: <CR> accepts, <Tab> is free for us to redefine below.
			-- (super-tab's <Tab> calls select_and_accept immediately on the highlighted
			-- item instead of just moving the highlight — that's the bug you hit)
			preset = "enter",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
			-- your colorscheme styles nvim-cmp's highlight groups (see colorscheme.lua),
			-- not blink's native ones, so fall back to those to keep the popup matching
			use_nvim_cmp_as_default = true,
		},
		completion = {
			menu = {
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				draw = {
					-- icon (fast visual scan) + label + auto-import source, no spelled-out
					-- kind text (e.g. "Function") since the icon already covers that
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
				},
			},
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				},
			},
			-- replaces the old nvim-autopairs <-> cmp integration hook
			accept = {
				auto_brackets = { enabled = true },
			},
			-- inline preview of the selected item as virtual text
			ghost_text = { enabled = false },
		},
		-- automatic signature help popup while typing inside (); your <C-k> manual
		-- trigger in lsp.lua still works too, this just adds the automatic version
		signature = {
			enabled = true,
			window = {
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			},
		},
		-- no snippets source: dropped LuaSnip/friendly-snippets since they weren't used much
		sources = {
			default = { "lsp", "path", "buffer" },
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				menu = { auto_show = true },
			},
		},
		-- prebuilt Rust matcher when available, falls back to the Lua one with a warning
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
