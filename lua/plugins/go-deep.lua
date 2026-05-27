---@type PackSpec
return {
	src = "/home/sami/personal/projects/go-deep.nvim",
	build = function(path)
		require("go_deep").build(path)
	end,
	config = function()
		vim.g.go_deep = {
			min_keyword_length = 3,
			max_items = 10,
			exclude_vendored_packages = false,
			exclude_internal_packages = true,
			exclude_test_files = true,
			loglevel = "info",
			notifications = true,
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.name == "gopls" then
					require("go_deep").attach_to_buffer(ev.buf)
				end
			end,
		})
	end,
}
