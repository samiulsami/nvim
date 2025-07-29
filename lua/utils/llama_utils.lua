--- Command to start the server:
--- export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1; build/bin/llama-server -m qwencoder2.5-coder3b.gguf --port 11397 --n-gpu-layers 500 -fa -dt 0.6 --ubatch-size 512 --batch-size 1024 --ctx-size 0 --cache-reuse 512

---@class utils.llama_utils
---@field status fun (self): boolean
---@field private host string
---@field private port integer
---@field public endpoint function(self): string
local llama_utils = {}

llama_utils.host = "127.0.0.1"
llama_utils.port = 11397

---@return boolean
function llama_utils:status()
	local socket = vim.uv.new_tcp()
	if not socket then
		return false
	end
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

function llama_utils:endpoint()
	return self.host .. ":" .. self.port .. "/infill"
end

return llama_utils
