# Neovim PDE Based on kickstart.nvim

## Setup in Ubuntu:
```bash
sudo apt update
sudo apt install build-essential unzip git python3.12-venv xclip cmake gettext fd-find ripgrep 
sudo ln -s $(which fdfind) /usr/bin/fd
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install 18
source ~/.bashrc
git clone https://github.com/neovim/neovim.git ~/neovim
cd ~/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
git clone https://github.com/samiulsami/nvimconfig.git ~/.config/nvim 
nvim
```

#### Set Neovim as default editor
```bash
sudo echo "export EDITOR='nvim -f'" >> ~/.bashrc
git config --global core.editor 'nvim -f'
```
## Notes
- `<leader>` key is space
- Press `<leader>sk` to search keybinds
- Most plugin keybinds are defined in their respective `.lua` file
- LSPs, Mason packages, and Treesitter configs are defined in lua/data/
