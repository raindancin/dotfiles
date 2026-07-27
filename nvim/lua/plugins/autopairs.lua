return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	-- bracket-insertion on completion accept is now handled by blink.cmp's
	-- completion.accept.auto_brackets (see blink.lua) — nvim-cmp's confirm_done
	-- event hook this used to need doesn't exist in blink, so it's dropped here.
	-- This plugin now only handles normal typed-bracket pairing.
	opts = {
		fast_wrap = false,
		disable_filetype = { "TelescopePrompt", "vim" },
	},
}
