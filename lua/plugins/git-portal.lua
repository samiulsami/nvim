return {
	"https://codeberg.org/trevorhauter/gitportal.nvim",
	config = function()
		local gitportal = require("gitportal")
		gitportal.setup({
			always_include_current_line = true, -- Include the current line in permalinks by default
		})
		vim.keymap.set(
			{ "n", "v" },
			"<leader>G",
			gitportal.to_remote,
			{desc = "Open the current line or selection in Git web interface" }
		)
	end,
}
