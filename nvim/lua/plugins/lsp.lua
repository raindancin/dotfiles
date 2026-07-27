return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
					source = "if_many",
				},
				signs = {
					text = {
						-- icons ERROR: 󰅙,  INFO: 󰋼,
						[vim.diagnostic.severity.ERROR] = "󰅙",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "󰋼",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
					focusable = false,
				},
			})
			vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx)
				vim.lsp.handlers.hover(_, result, ctx, { border = "rounded" })
			end
			vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx)
				vim.lsp.handlers.signature_help(_, result, ctx, { border = "rounded" })
			end
			-- LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", vim.lsp.buf.definition, "Goto Definition")
					map("gr", vim.lsp.buf.references, "Goto References")
					map("gI", vim.lsp.buf.implementation, "Goto Implementation")
					map("gy", vim.lsp.buf.type_definition, "Type Definition")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>cf", function()
						vim.lsp.buf.format({ async = true })
					end, "Format")
					map("K", vim.lsp.buf.hover, "Hover")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- Document highlight
					if client and client:supports_method("textDocument/documentHighlight") then
						local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
					end
					-- Inlay hints toggle
					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})
			-- Merge blink.cmp's enhanced completion capabilities into every LSP server.
			-- (note: the old cmp_nvim_lsp version built `capabilities` but never actually
			-- passed it to vim.lsp.config, so servers weren't getting it before either)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			-- Enable LSP servers
			vim.lsp.enable({
				"lua_ls",
				"pyright",
				"rust_analyzer",
				"clangd",
			})
		end,
	},
}
