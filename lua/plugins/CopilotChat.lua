-- Premium request multipliers (ref: https://docs.github.com/en/copilot/concepts/billing/copilot-requests)
-- GPT-4.1                      0
-- GPT-5 mini                   0
-- GPT-4o                       0
-- Gemini 2.0 Flash             0.25
-- o4-mini                      0.33
-- o3                           1
-- GPT-5                        1
-- Claude Sonnet 3.5            1
-- Claude Sonnet 3.7            1
-- Claude Sonnet 4              1
-- Gemini 2.5 Pro               1
-- Claude Sonnet 3.7 Thinking   1.25
-- Claude Opus 4.1              10
-- Claude Opus 4                10
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
				prompts = {
					think = {
						prompt = "Make use of the 'sequentialthinking' tool to aid in reasoning and problem-solving.",
						system_prompt = require("CopilotChat.config.prompts").COPILOT_BASE.system_prompt,
						remember_as_sticky = true,
					},
				},
				model = "gpt-4.1",
				temperature = 0.1,
				window = {
					layout = "float",
					width = 1,
					height = 1,
					row = 9999999,
					blend = 10,
				},
				auto_insert_mode = false,
				sticky = {
					"@context7",
					"@kubernetes",
					"@neovim_list_directory",
					"@neovim_find_files",
					"@neovim_execute_command",
					"@neovim_read_multiple_files",
					"@sequential_thinking",
				},
				mappings = {
					close = {
						normal = "<Esc>",
						insert = "<C-c>",
						callback = function()
							chat.save(vim.fn.sha256(vim.fn.getcwd()))
							chat.close()
						end,
					},
				},
			})

			vim.keymap.set({ "n", "v", "i" }, "<A-c>", function()
				chat.toggle()
			end, { noremap = true, silent = true, desc = "Copilot Chat: Toggle" })

			vim.keymap.set({ "n", "i" }, "<A-m>", function()
				chat.select_model()
			end, { noremap = true, silent = true, desc = "Copilot Chat: Select model" })

			vim.api.nvim_create_autocmd("VimEnter", {
				once = true,
				callback = function()
					local cwd = vim.fn.getcwd()
					local ok, _ = pcall(chat.load, vim.fn.sha256(cwd))
					if ok then
						vim.notify("Copilot Chat: Loaded previous session at " .. cwd, vim.log.levels.INFO)
					end
				end,
			})

			vim.api.nvim_create_autocmd("VimLeavePre", {
				once = true,
				callback = function()
					pcall(chat.save, vim.fn.sha256(vim.fn.getcwd()))
				end,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true
					vim.opt_local.wrap = true
					vim.opt_local.conceallevel = 0
				end,
			})
		end,
	},
}
