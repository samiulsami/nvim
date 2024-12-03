# Neovim PDE Based on kickstart.nvim

## Setup in Ubuntu:
```
sudo apt update
sudo apt install build-essential unzip git python3.12-venv xclip cmake gettext fd-find ripgrep 
sudo ln -s $(which fdfind) /usr/bin/fd
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
git clone https://github.com/samiulsami/nvimconfig.git ~/.config/nvim 
```

#### <i>Nerd font for icons</i>

<i>Must be manually set in the terminal emulator</i>
```
sudo cp ~/.config/nvim/fonts/* /usr/share/fonts/
sudo fc-cache -f -v
```
#### Set Neovim as default editor
```
sudo echo "export EDITOR='nvim -f'" >> ~/.bashrc
git config --global core.editor 'nvim -f'
```
##### <i>(Optional) Node.js for yaml/json language servers, and markdown-preview</i>
```
wget -q -O- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install 18 
```
## Notes
- `<leader>` key is space
- Press `<leader>sk` to search keybinds with Telescope
- Most plugin keybinds are defined in their respective `.lua` file
- Language Servers, Mason packages, and Treesitter configs are defined in lua/data/
