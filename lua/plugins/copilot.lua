--- Premium request multipliers (ref: https://docs.github.com/en/copilot/concepts/billing/copilot-requests)
--- GPT-4.1                      0
--- GPT-5 mini                   0
--- GPT-5                        0
--- GPT-4o                       0
--- Gemini 2.0 Flash             0.25
--- o4-mini                      0.33
--- o3                           1
--- GPT-5                        1
--- Claude Sonnet 3.5            1
--- Claude Sonnet 3.7            1
--- Claude Sonnet 4              1
--- Gemini 2.5 Pro               1
--- Claude Sonnet 3.7 Thinking   1.25
--- Claude Opus 4.1              10
--- Claude Opus 4                10

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VimEnter",
	config = function()
		local enable_copilot = not require("utils.llama"):status()
		if not enable_copilot then
			vim.notify("Disabling Copilot because llama.vim is active", vim.log.levels.WARN)
			return
		end

		require("copilot").setup({
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = enable_copilot,
				auto_trigger = false,
				hide_during_completion = false,
				debounce = 75,
				trigger_on_accept = true,
			},
			filetypes = { ["*"] = true },
			disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
			root_dir = function()
				return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
			end,
		})

		local spinner = {
			max_length = 50,
			min_length = 15,
			repeat_ms = 50,
			timer = nil,
			-- stylua: ignore
			chars = {
				"Ȁ", "ȁ", "Ș", "ș", "Ț", "ț", "Ȝ", "ȝ", "ȿ", "Ⱥ", "Ⱦ", "Ƚ", "Ҁ", "ҁ", "Ҍ", "ҍ", "Ґ", "ґ", "Ғ", "ғ", "Җ", "җ", "Қ", "қ", "Ң", "ң", "Ү", "ү", "Ҽ", "ҽ",
				"א", "ב", "ג", "ד", "ה", "ו", "ز", "ح", "خ", "ک", "ګ", "ڭ", "گ", "ھ", "ۀ", "ہ", "ۃ", "ۄ", "ۅ", "ۆ", "ۇ", "ۈ", "ۉ", "ۊ", "ۋ", "ی",
				"α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω",
				"Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω",
				"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
				"@", "#", "$", "%", "&", "*", "+", "-", "=", "~", "?", "!", "/", "\\", "|", "<", ">", "^",
				"∂", "∑", "∏", "∫", "√", "∞", "≈", "≠", "≤", "≥", "⊕", "⊗", "⊥", "∇", "∃", "∀", "∈", "∉", "∩", "∪", "∧", "∨",
				"♠", "♥", "♦", "♣", "♪", "♫", "☼", "☽", "☾"
			},
			hl = { "CopilotSpinnerHL1", "CopilotSpinnerHL2", "CopilotSpinnerHL3" },
			ns = vim.api.nvim_create_namespace("custom_copilot_spinner"),
		}

		vim.api.nvim_set_hl(0, spinner.hl[1], { fg = "#ff0000", bold = true })
		vim.api.nvim_set_hl(0, spinner.hl[2], { fg = "#000000", bold = true })
		vim.api.nvim_set_hl(0, spinner.hl[3], { fg = "#ff3333", bold = true })

		function spinner:next_string()
			local result = {}
			local length = math.random(self.min_length, self.max_length)
			for _ = 1, length do
				local index = math.random(1, #self.chars)
				table.insert(result, self.chars[index])
			end
			return table.concat(result)
		end

		function spinner:reset()
			vim.api.nvim_buf_clear_namespace(0, self.ns, 0, -1)
			if self.timer then
				self.timer:stop()
				self.timer = nil
			end
		end

		vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertLeave" }, {
			callback = function()
				spinner:reset()
			end,
		})

		require("copilot.status").register_status_notification_handler(function(data)
			spinner:reset()
			if data.status == "InProgress" then
				if spinner.timer then
					spinner.timer:stop()
				end
				spinner.timer = vim.uv.new_timer()
				if not spinner.timer then
					return
				end
				--stylua: ignore start
				spinner.timer:start(
					0,
					spinner.repeat_ms,
					vim.schedule_wrap(function()
						if require('copilot.suggestion').is_visible() then
							spinner:reset()
							return
						end

						local pos = vim.api.nvim_win_get_cursor(0)
						local row, col = pos[1] - 1, pos[2]
						local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
						if col > #line then
							col = #line
						end

						local extmark_id = vim.api.nvim_buf_set_extmark(
							0,
							spinner.ns,
							row,
							col,
							{ virt_text = { { spinner:next_string(), spinner.hl[math.random(1, #spinner.hl)]} }, virt_text_pos = "inline", priority = 0 }
						)

						vim.defer_fn(function()
							pcall(vim.api.nvim_buf_del_extmark, 0, spinner.ns, extmark_id)
						end, spinner.repeat_ms)
					end)
				)
				-- stylua: ignore end
			else
				spinner:reset()
			end
		end)

		local copilot_suggestion = require("copilot.suggestion")
		vim.keymap.set("i", "<C-o>", function()
			if copilot_suggestion.is_visible() then
				copilot_suggestion.accept_line()
			else
				copilot_suggestion.next()
			end
		end, { desc = "Accept Copilot suggestion (Line)" })

		vim.keymap.set("i", "<C-j>", function()
			if copilot_suggestion.is_visible() then
				copilot_suggestion.accept_word()
			else
				copilot_suggestion.next()
			end
		end, { desc = "Accept Copilot suggestion (Word)" })
	end,
}
