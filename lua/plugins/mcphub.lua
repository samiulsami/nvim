return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	event = "VeryLazy",
	config = function()
		require("mcphub").setup({
                        auto_approve = function(parsed_params)
                                return parsed_params and parsed_params.is_auto_approved_in_server or false
                        end,
			extensions = {
				copilotchat = {
					enabled = true,
					convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
					convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
					add_mcp_prefix = false, -- Add "mcp_" prefix to function names
				},
			},
		})
	end,
}
