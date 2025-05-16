--- build/bin/llama-server -m qwen2.5-coder-3B.gguf --port 11397 -ngl 500 -fa -dt 0.1 \
                                      --ubatch-size 512 --batch-size 1024 \
                                      --ctx-size 4096 --cache-reuse 256

---@class utils.llama_utils
---@field status fun (self): boolean
---@field public host string
---@field public port integer
local llama_utils = {}

llama_utils.host = "127.0.0.1"
llama_utils.port = 11397

---@return boolean
function llama_utils:status()
	local socket = vim.uv.new_tcp()
	local done = false
	local success = false

	socket:connect(self.host, self.port, function(err)
		success = err == nil
		done = true
	end)

	vim.wait(100, function()
		return done
	end, 10)
	socket:close()
	return success
end

return llama_utils
