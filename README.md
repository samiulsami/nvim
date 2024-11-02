## Neovim PDE for cpp/go.

### Setup in Ubuntu:
```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install build-essential ripgrep unzip git python3.12-venv xclip neovim
sudo rm -rf ~/.config/nvim
git clone https://github.com/samiulsami/nvimconfig.git ~/.config/nvim 
sudo cp ~/.config/nvim/fonts/* /usr/share/fonts/
sudo fc-cache -f -v
sudo echo "export EDITOR='nvim -f'" >> ~/.bashrc
git config --global core.editor 'nvim -f'
```

###
//TODO
