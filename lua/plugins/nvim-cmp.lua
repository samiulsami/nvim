return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},

		config = function()
			local cmp = require("cmp")

			local buffer_source = {
				name = "buffer",
				keyword_length = 2,
				max_item_count = 10,
				option = {
					get_bufnrs = function()
						local buf = vim.api.nvim_get_current_buf()
						local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						if byte_size > 1024 * 1024 then -- 1MB MAX
							return {}
						end
						return { buf }
					end,
				},
			}

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { buffer_source },
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path", keyword_length = 3 },
					{ name = "cmdline", keyword_length = 2 },
					buffer_source,
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
