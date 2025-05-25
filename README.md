# Neovim config based on kickstart.nvim

#### Requirements
```bash
sudo apt update
sudo apt install build-essential unzip git python3.12-venv xclip cmake gettext ripgrep 

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#fd
sudo apt install fd
sudo ln -s $(which fdfind) /usr/bin/fd

#rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#nodejs
curl -fsSL https://fnm.vercel.app/install | zsh
source ~/.zshrc
fnm install 24
```
#### Build and configure
```bash
git clone https://github.com/neovim/neovim.git ~/neovim
cd ~/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Setup plugins
git clone https://github.com/samiulsami/nvimconfig.git ~/.config/nvim 
nvim
```


#### Set Neovim as default editor
```bash
sudo echo "export EDITOR='nvim -f'" >> ~/.zshrc
git config --global core.editor 'nvim -f'
```
## Notes
- `<leader>` key is space
- Press `<leader>sk` to search keybinds
- Most plugin keybinds are defined in their respective `.lua` file
