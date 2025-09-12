--- git clone git@github.com:ggml-org/llama.cpp.git
--- cd llama.cpp
--- cmake -B build -DGGML_CUDA=ON
--- cmake --build build --config Release
--- pip install -r requirements.txt --break-system-packages
---Either:
--- huggingface-cli download Qwen/qwen2.5-coder1.5b --local-dir ~/models/Qwen/qwen2.5-coder1.5b --local-dir-use-symlinks False
---local-dir ~/models/Qwen/qwen2.5-coder1.5b --local-dir-use-symlinks False
--- python3 convert_hf_to_gguf.py ~/models/Qwen/qwen2.5-coder1.5b --outfile qwen2.5-coder1.5b --outtype q8_0
--- export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1; build/bin/llama-server -m qwencoder2.5-coder1.5b.gguf --port 11397 --n-gpu-layers 500 -fa -dt 0.6 --ubatch-size 512 --batch-size 1024 --ctx-size 0 --cache-reuse 512
---OR:
--- export GGML_CUDA_ENABLE_UNIFIED_MEMORY=1; build/bin/llama-server -m --fim-qwen-1.5b-default --port 11397 --n-gpu-layers 500 -dt 0.6 --ubatch-size 512 --batch-size 1024 --ctx-size 0 --cache-reuse 512

---@class utils.llama
---@field status fun (self): boolean
---@field private host string
---@field private port integer
---@field public endpoint function(self): string
local llama = {}

llama.host = "127.0.0.1"
llama.port = 11397

---@return boolean
function llama:status()
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

function llama:endpoint()
	return self.host .. ":" .. self.port .. "/infill"
end

return llama
