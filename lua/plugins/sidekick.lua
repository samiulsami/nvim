return {
	"folke/sidekick.nvim",
	lazy = false,
	config = function()
		local sidekick = require("sidekick")
		sidekick.setup({
			cli = { watch = false },
			nes = { diff = { inline = "chars" } },
		})

		local sidekick_cli = require("sidekick.cli")
		vim.keymap.set({ "n", "v" }, "<A-c>", function()
			local relative_path = vim.fn.expand("%:.")
			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")

			if start_line > end_line then
				start_line, end_line = end_line, start_line
			end

			sidekick_cli.send({
				name = "opencode",
				msg = string.format("%s:%d-%d\n{selection}", relative_path, start_line, end_line),
				focus = false,
			})
		end, { desc = "Sidekick send to cli" })

		local sidekick_nes = require("sidekick.nes")

		vim.keymap.set({ "n", "i" }, "<A-;>", function()
			if sidekick_nes.have() then
				sidekick_nes.apply()
			end
		end, { desc = "Show Sidekick NES" })
	end,
}
