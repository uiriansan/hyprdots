return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-CR>"] = { "select_and_accept" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				-- ["<C-K>"] = { "show_signature", "hide_signature", "fallback" },
			},
			signature = { enabled = true },
			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				trigger = {
					-- When true, will prefetch the completion items when entering insert mode
					prefetch_on_insert = true,

					-- When false, will not show the completion window automatically when in a snippet
					show_in_snippet = true,

					-- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
					show_on_keyword = true,

					-- When true, will show the completion window after typing a trigger character
					show_on_trigger_character = true,

					-- LSPs can indicate when to show the completion window via trigger characters
					-- however, some LSPs (i.e. tsserver) return characters that would essentially
					-- always show the window. We block these by default.
					show_on_blocked_trigger_characters = function()
						if vim.api.nvim_get_mode().mode == "c" then
							return {}
						end

						-- you can also block per filetype, for example:
						-- if vim.bo.filetype == 'markdown' then
						--   return { ' ', '\n', '\t', '.', '/', '(', '[' }
						-- end

						return { " ", "\n", "\t" }
					end,

					-- When both this and show_on_trigger_character are true, will show the completion window
					-- when the cursor comes after a trigger character after accepting an item
					show_on_accept_on_trigger_character = true,

					-- When both this and show_on_trigger_character are true, will show the completion window
					-- when the cursor comes after a trigger character when entering insert mode
					show_on_insert_on_trigger_character = true,

					-- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
					-- the completion window when the cursor comes after a trigger character when
					-- entering insert mode/accepting an item
					show_on_x_blocked_trigger_characters = { "'", '"', "(" },
					-- or a function, similar to show_on_blocked_trigger_character
				},
				list = {
					-- Maximum number of items to display
					max_items = 200,

					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = true,
						-- preselect = function(ctx) return ctx.mode ~= 'cmdline' end,

						-- When `true`, inserts the completion item automatically when selecting it
						-- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
						-- which will both undo the selection and hide the completion menu
						auto_insert = true,
						-- auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
					},

					cycle = {
						-- When `true`, calling `select_next` at the *bottom* of the completion list
						-- will select the *first* completion item.
						from_bottom = true,
						-- When `true`, calling `select_prev` at the *top* of the completion list
						-- will select the *last* completion item.
						from_top = true,
					},
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
}
