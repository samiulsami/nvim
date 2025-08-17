return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		config = function()
			local chat = require("CopilotChat")
			chat.setup({
				model = "gpt-4.1", -- AI model to use
				temperature = 0.4, -- Lower = focused, higher = creative
				window = {
					layout = "vertical", -- 'vertical', 'horizontal', 'float'
					width = 0.5,
					height = 1,
					blend = 22,
				},
				auto_insert_mode = false, -- Enter
			})

			vim.keymap.set(
				"n",
				"<A-c>",
				"<Cmd>CopilotChatToggle<CR>",
				{ noremap = true, silent = true, desc = "Copilot Chat: toggle" }
			)

			vim.keymap.set(
				"n",
				"<A-m>",
				"<Cmd>CopilotChatModels<CR>",
				{ noremap = true, silent = true, desc = "Copilot Chat: Select model" }
			)
		end,
	},
}
