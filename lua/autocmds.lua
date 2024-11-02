vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#BF4040", ctermbg = "Red" }) vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 }) end })

