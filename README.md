# Neovim config based on kickstart.nvim

#### Requirements
```bash
sudo apt update
sudo apt install build-essential unzip git python3.12-venv xclip cmake gettext ripgrep 

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

#fd
sudo apt install fd
sudo ln -s $(which fdfind) /usr/bin/fd

#rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

#nodejs
curl -fsSL https://fnm.vercel.app/install | zsh
source $HOME/.zshrc
fnm install 24
```

#### jdtls (optional)
- setup java (21+)<br>
- download [jdtls latest](https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz)<br>
- extract jdtls to `$HOME/.eclipse_jdtls`, make sure you have the `plugins`/`bin`/etc. dirs in the `$HOME/.eclipse_jdtls` folder<br>
- if needed, follow the steps here https://github.com/mfussenegger/nvim-jdtls<br>

#### Build and configure

```bash
git clone https://github.com/neovim/neovim.git $HOME/neovim
cd $HOME/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Setup plugins
git clone https://github.com/samiulsami/nvimconfig.git $HOME/.config/nvim
nvim
```

#### Set Neovim as default editor
```bash
sudo echo "export EDITOR='nvim -f'" >> $HOME/.zshrc
git config --global core.editor 'nvim -f'
```
## Notes
- `<leader>` key is space
- Press `<leader>sk` to search keybinds
- Most plugin keybinds are defined in their respective `.lua` file
