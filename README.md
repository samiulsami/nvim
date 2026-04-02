# Neovim Config Based on kickstart.nvim

#### Requirements
- ripgrep
- xclip/wl-clipboard
- fzf
- CMake
- rustup
- unzip

#### jdtls (optional)
- set up java (21+)<br>
- download [jdtls latest](https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz)<br>
- Extract jdtls to `$XDG_DATA_HOME/eclipse_jdtls`, make sure you have the `plugins`/`bin`/etc. dirs in the `$XDG_DATA_HOME/eclipse_jdtls` folder<br>
- if needed, follow the steps here https://github.com/mfussenegger/nvim-jdtls<br>

#### Build from Source and Configure

```bash
git clone https://github.com/neovim/neovim.git $HOME/neovim
cd $HOME/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

# Setup plugins
git clone https://github.com/samiulsami/nvimconfig.git $HOME/.config/nvim
nvim
```

#### Set Neovim as Default Editor
```bash
sudo echo "export EDITOR='nvim -f'" >> $HOME/.zshrc
git config --global core.editor 'nvim -f'
```
## Notes
- `<leader>` key is space
- Press `<leader>sk` to search keybinds
- Most plugin keybinds are defined in their respective `.lua` file in `./lua/plugins/*`
