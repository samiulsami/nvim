return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first

	config = function()
		require("tiny-inline-diagnostic").setup({
			options = {
				show_source = true,
				use_icons_from_diagnostic = true,
				set_arrow_to_dia_color = true,
				throttle = 100,
				show_all_diags_on_cursorline = true,
				multilines = {
					enabled = false,
					always_show = false,
				},
				virt_texts = {
					priority = 9999,
				},
			},
		})

		vim.diagnostic.config({ virtual_text = false })
		vim.keymap.set("n", "<leader>td", function()
			require("tiny-inline-diagnostic").toggle()
		end, { noremap = true, desc = "[T]oggle tiny inline [D]iagnostic", silent = true })
	end,
}
