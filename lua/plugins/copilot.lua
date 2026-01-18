--- Premium request multipliers (ref: https://docs.github.com/en/copilot/concepts/billing/copilot-requests)

return {
	"zbirenbaum/copilot.lua",
	lazy = false,
	cmd = "Copilot",
	event = "VimEnter",
	dependencies = { "samiulsami/copilot-eldritch.nvim" },
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 0,
				trigger_on_accept = false,
			},
			nes = {
				enabled = false,
				auto_trigger = false,
				keymap = {
					accept_and_goto = "<A-;>",
					accept = false,
					dismiss = false,
				},
			},
			workspace_folders = { vim.fn.getcwd() },
			filetypes = { ["*"] = true },
			disable_limit_reached_message = false,
			root_dir = function()
				return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
			end,
		})

		require("copilot-eldritch").setup()
		local copilot_suggestion = require("copilot.suggestion")

		vim.keymap.set("i", "<C-o>", function()
			vim.b.copilot_suggestion_hidden = false
			if copilot_suggestion.is_visible() then
				vim.b.copilot_custom_clear_on_move = false
				copilot_suggestion.accept_line()
				return
			end
			vim.b.copilot_custom_clear_on_move = true
			copilot_suggestion.update_preview()
		end, { desc = "Accept Copilot suggestion (Word)" })

		vim.keymap.set("i", "<A-o>", function()
			vim.b.copilot_suggestion_hidden = false
			if copilot_suggestion.is_visible() then
				vim.b.copilot_custom_clear_on_move = false
				copilot_suggestion.accept_word()
				return
			end
			vim.b.copilot_custom_clear_on_move = true
			copilot_suggestion.update_preview()
		end, { desc = "Accept Copilot suggestion (Line)" })

		vim.b.copilot_suggestion_hidden = true
		vim.b.copilot_custom_clear_on_move = false
		vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter", "InsertLeave", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("CopilotEldritchVisibility", { clear = true }),
			callback = function()
				if vim.b.copilot_custom_clear_on_move or vim.b.copilot_suggestion_hidden then
					copilot_suggestion.clear_preview()
				end
				vim.b.copilot_suggestion_hidden = true
				vim.b.copilot_custom_clear_on_move = false
			end,
		})
	end,
}
