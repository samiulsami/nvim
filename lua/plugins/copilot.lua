--- Premium request multipliers (ref: https://docs.github.com/en/copilot/concepts/billing/copilot-requests)
--- Raptor mini                  0
--- GPT-4.1                      0
--- GPT-5 mini                   0
--- GPT-5                        0
--- GPT-4o                       0
--- Grok Code Fast 1             0.25
--- Claude Haiku 4.5             0.33
--- GPT-5.1-Codex-Mini           0.33
--- GPT-5.1-Codex                1
--- GPT-5                        1
--- GPT-5.1                      1
--- Claude Sonnet 4              1
--- Claude Sonnet 4.5            1
--- Gemini 2.5 Pro               1
--- Claude Opus 4.1              10

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VimEnter",
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
			workspace_folders = { vim.fn.getcwd() },
			filetypes = { ["*"] = true },
			disable_limit_reached_message = false,
			root_dir = function()
				return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
			end,
		})

		local spinner = {
			max_length = 73,
			min_length = 1,
			max_distance_from_cursor = 10,
			max_lines = 3,
			repeat_ms = 50,

			-- stylua: ignore
			chars = { "Ȁ", "ȁ", "Ș", "ș", "Ț", "ț", "Ȝ", "ȝ", "ȿ", "Ⱥ", "Ⱦ", "Ƚ", "Ҁ", "ҁ", "Ҍ", "ҍ", "Ґ", "ґ", "Ғ", "ғ", "Җ",
				"җ", "Қ", "қ", "Ң", "ң", "Ү", "ү", "Ҽ", "ҽ", "א", "ב", "ג", "ד", "ה", "ו", "ز", "ح", "خ", "ک", "ګ", "ڭ",
				"گ", "ھ", "ۀ", "ہ", "ۃ", "ۄ", "ۅ", "ۆ", "ۇ", "ۈ", "ۉ", "ۊ", "ۋ", "ی", "α", "β", "γ", "δ", "ε", "ζ", "η",
				"θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω", "Α", "Β", "Γ", "Δ",
				"Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω", "0",
				"1", "2", "3", "4", "5", "6", "7", "8", "9", "@", "#", "$", "%", "&", "*", "+", "-", "=", "~", "?", "!",
				"/", "\\", "|", "<", ">", "^", "∂", "∑", "∏", "∫", "√", "∞", "≈", "≠", "≤", "≥", "⊕", "⊗", "⊥", "∇", "∃",
				"∀", "∈", "∉", "∩", "∪", "∧", "∨", "♠", "♥", "♣", "♪", "♫", "☼", "☽", "☾", "☿", "♃", "♄", "⚳", "⚴",
				"⚵", "⚶", "⚷", "⚸", "⚹", "⚺", "ꙮ", "꙯", "꙰", "꙱", "꙲", "꙳", "ꙴ", "ꙵ", "ꙶ", "ꙷ", "ꙸ", "ꙹ", "ꙺ", "ꙻ", "꙼",
				"꙽", "꙾", "ꙿ", "𐌀", "𐌁", "𐌂", "𐌃", "𐌄", "𐌅", "𐌆", "𐌇", "𐌈", "𐌉", "𐌊", "𐌋", "𐌌", "𐌍", "𐌎", "𐌏", "𐌐", "𐌑",
				"𐌒", "𐌓", "𐌔", "𐌕", "𓂀", "𓂁", "𓂂", "𓂃", "𓂄", "𓂅", "𓂆", "𓂇", "𓂈", "𓂉", "𓂊", "𓂋", "𓂌", "𓂍", "𓂎", "𓂏", "𓂐",
				"𓂑", "𓂒", "𓂓", "𓂔", "𓂕", "𓂖", "𓂗", "𓂘", "𓂙", "𓂚", "𓂛", "𓂜", "𓂝", "𓂞", "𓂟", "𓂠", "𓂡", "𓂢", "𓂣", "𓂤", "𓂥",
				"𓂦", "𓂧", "𓂨", "𓂩", "𓂪", "𓂫", "𓂬", "𓂭", "𓂮", "𓂯", "𓂰", "𓂱", "𓂲", "𓂳", "𓂴", "𓂵", "𓂶", "𓂷", "𓂸", "𓂹", "𓂺",
				"𓂻", "𓂼", "𓂽", "𓂾", "𓂿", "𓃀", "𓃁", "𓃂", "𓃃", "𓃄", "𓃅", "𓃆", "𓃇", "𓃈", "𓃉", "𓃊", "𓃋", "𓃌", "𓃍", "𓃎", "𓃏",
				"𓃐", "𓃑", "𓃒", "𓃓", "𓃔", "𓃕", "𓃖", "𓃗", "𓃘", "𓃙", "𓃚", "𓃛", "𓃜", "𓃝", "𓃞", "𓃟", "𓃠", "𓃡", "𓃢", "𓃣", "𓃤",
				"𓃥", "𓃦", "𓃧", "𓃨", "𓃩", "𓃪", "𓃯", "𓃰", "𓃱", "𓃲", "𓃳", "𓃴", "𓃵", "𓃶", "𓃷", "𓃸", "𓃹", "𓃺", "𓃻", "𓃼", "𓃽", "𓃾", "𓃿" },
			rand_hl_group = "CopilotSpinnerHLGroup",
			ns = vim.api.nvim_create_namespace("custom_copilot_spinner"),
			timer = nil,
		}

		function spinner:next_string()
			local result = {}
			local spaces = math.random(0, self.max_distance_from_cursor)
			for _ = 1, spaces do
				table.insert(result, " ")
			end

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

		require("copilot.status").register_status_notification_handler(function(data)
			spinner:reset()
			if data.status ~= "InProgress" then
				return
			end

			if spinner.timer then
				spinner.timer:stop()
			end
			spinner.timer = vim.uv.new_timer()
			if not spinner.timer then
				return
			end

			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("CopilotSpinnerInsertLeave", { clear = true }),
				once = true,
				callback = function()
					spinner:reset()
				end,
			})

			spinner.timer:start(
				0,
				spinner.repeat_ms,
				vim.schedule_wrap(function()
					if vim.b.copilot_suggestion_hidden then
						return
					end
					if require("copilot.suggestion").is_visible() then
						spinner:reset()
						return
					end

					local pos = vim.api.nvim_win_get_cursor(0)
					local cursor_row, cursor_col = pos[1] - 1, pos[2]
					local cursor_line = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)[1] or ""
					if cursor_col > #cursor_line then
						cursor_col = #cursor_line
					end

					vim.api.nvim_set_hl(0, spinner.rand_hl_group, {
						fg = "#" .. string.format("%02x", math.random(133, 255)) .. "0044",
						bold = true,
					})

					local extmark_ids = {}
					local num_lines = math.random(1, spinner.max_lines)
					local buf_line_count = vim.api.nvim_buf_line_count(0)

					for i = 1, num_lines do
						local row = cursor_row + i - 1
						if row >= buf_line_count then
							break
						end
						local col = (i == 1) and cursor_col or 0

						local extmark_id = vim.api.nvim_buf_set_extmark(0, spinner.ns, row, col, {
							virt_text = { { spinner:next_string(), spinner.rand_hl_group } },
							virt_text_pos = "overlay",
							priority = 0,
						})
						table.insert(extmark_ids, extmark_id)
					end

					vim.defer_fn(function()
						for _, extmark_id in ipairs(extmark_ids) do
							pcall(vim.api.nvim_buf_del_extmark, 0, spinner.ns, extmark_id)
						end
					end, spinner.repeat_ms + math.random(1, 100))
				end)
			)
		end)

		local copilot_suggestion = require("copilot.suggestion")

		vim.b.copilot_suggestion_hidden = true
		vim.b.copilot_custom_clear_on_move = false
		vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter", "InsertLeave", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("CopilotSuggestionHideGroup", { clear = true }),
			callback = function()
				if vim.b.copilot_custom_clear_on_move or vim.b.copilot_suggestion_hidden then
					copilot_suggestion.clear_preview()
				end
				vim.b.copilot_suggestion_hidden = true
				vim.b.copilot_custom_clear_on_move = false
			end,
		})

		vim.keymap.set("i", "<C-o>", function()
			vim.b.copilot_suggestion_hidden = false
			if copilot_suggestion.is_visible() then
				vim.b.copilot_custom_clear_on_move = false
				copilot_suggestion.accept_line()
				return
			end
			vim.b.copilot_custom_clear_on_move = true
			copilot_suggestion.update_preview()
		end, { desc = "Accept Copilot suggestion (Line)" })

		vim.keymap.set("i", "<C-i>", function()
			vim.b.copilot_suggestion_hidden = false
			if copilot_suggestion.is_visible() then
				vim.b.copilot_custom_clear_on_move = false
				copilot_suggestion.accept_word()
				return
			end
			vim.b.copilot_custom_clear_on_move = true
			copilot_suggestion.update_preview()
		end, { desc = "Accept Copilot suggestion (Word)" })
	end,
}
