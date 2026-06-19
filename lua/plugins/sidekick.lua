---@type PluginSpec
return {
	src = "https://github.com/folke/sidekick.nvim",
	config = function()
		local sidekick = require("sidekick")
		sidekick.setup({
			cli = { watch = false },
			nes = { enabled = true },
		})

		local sidekick_cli = require("sidekick.cli")
		vim.keymap.set({ "n", "v" }, "<A-c>", function()
			local full_path = vim.fn.expand("%:p")

			local start_line = vim.fn.line("v")
			local end_line = vim.fn.line(".")

			if start_line > end_line then
				start_line, end_line = end_line, start_line
			end

			local line_ref = start_line == end_line and string.format("#%d ", start_line)
				or string.format("[offset=%d, limit=%d]", start_line, end_line - start_line)

			sidekick_cli.send({
				name = "opencode",
				msg = string.format("\n@%s%s", full_path, line_ref),
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
