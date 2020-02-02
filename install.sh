#!/bin/sh

#
# Start-TODO: 
#      [ ] REF: git clone https://github.com/ctaylo21/jarvis.git
#      [ ] Linuxbrew or Homebrew Menu
#      [x] DEPENDENCIES - HOMEBREW FOR LINUX
#      [x]     Homebrew dependencies if you have sudo access:
#      [x]         Debian, Ubuntu, etc.
#      [x]             sudo apt-get install build-essential
#      [x]         Fedora, Red Hat, CentOS, etc.
#      [x]             sudo yum groupinstall 'Development Tools'
#      [x]     GCC - We recommend that you install GCC by running:
#      [x]         brew install gcc
#      [ ]     SUDO - verify user has sudo root for installing applications
#      [ ]         A=$(sudo -n -v 2>&1);test -z "$A" || echo $A|grep -q asswor
#      [ ]         was successful for me for the script. This expression gives 0 if the current user can call 'sudo' and 1 if not.
#      [ ]     TMUX install
#      [ ] dotFile mgmt
#              BACK-UP
#              SETUP
#      [x]         BASHRC $PATH STATEMENTS - HOMEBREW FOR LINUX
#      [x]             HOMEBREW FOR LINUX
#      [x]                 linuxbrew/bin: Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.
#      [x]                 Configure Homebrew in your ~/.bash_profile by running
#      [x]                     echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.bash_profile
#      [x]             RUBY
#      [x]                 Add Ruby to your PATH by running:
#      [x]                 PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH
#      [ ]             GCC/Compilers
#      [ ]                 For compilers to find libnsl you may need to set:
#      [ ]                     export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/libnsl/lib"
#      [ ]                     export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/libnsl/include"
#      [ ]
#      [ ]                 For pkg-config to find libnsl you may need to set:
#      [ ]                   export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/libnsl/lib/pkgconfig"
#      [ ]             ZSH
#      [ ]                 export ZSH=${HOME}/.oh-my-zsh
#                      vtop alias
#                      vimrc
#                      screenrc
#                          vtop
#                      tmux
#                          ???line264:~/.tmux/plugins/tpm/scripts/install_plugins.sh???
#      [ ]         ZSHRC
#      [ ]             . /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh  <--bashrc|zshrc
#      [ ]         NVIM dot files (init.vim)
#      [ ]             cp -R ./config/nvim/* ~/.config/nvim/
#      [ ] FZF
#      [ ]     set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
#      [ ]     To install useful keybindings and fuzzy completion:
#      [ ]     /home/linuxbrew/.linuxbrew/opt/fzf/install
#      [ ] ERRORS
#      [ ]     airline: Could not resolve airline theme "space". Themes have been migrated to
#                   github.com/vim-airline/vim-airline-themes.
#      [ ]     spaceship
#      [ ]         SPACESHIP: Failed to symlink /home/linuxbrew/.linuxbrew/lib/node_modules/spaceship-prompt/spaceship.zsh to
#                             /usr/local/share/zsh/site-functions.
#      [ ]     tmux
#      [ ]         unknown variable: TMUX_PLUGIN_MANAGER_PATH
#      [ ]         FATAL: Tmux Plugin Manager not configured in tmux.conf
#      [ ]         Aborting.
#      [ ]     nvim +UpdateRemotePlugins +qall
#      [ ]         Aborted (core dumped)
#      [ ]         rm ~/.config/nvim/space.vim
# End-TODO
#

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Greetings. Preparing to power up and begin diagnostics.$(tput sgr 0)"
echo "---------------------------------------------------------"

INSTALLDIR=$PWD

# 
# Homebrew for Linux
#
echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Checking for Homebrew installation.$(tput sgr 0)"
echo "---------------------------------------------------------"
brew="/home/linuxbrew/.linuxbrew/bin/brew"
yum="/usr/bin/yum"

if [ -f "$brew" ]
then
    echo "---------------------------------------------------------"
    echo "$(tput setaf 2)JARVIS: Homebrew is installed.$(tput sgr 0)"
    echo "---------------------------------------------------------"
else
    echo "------------------------------------------------------------------------------------------------------"
    echo "$(tput setaf 3)JARVIS: Installing Homebrew. More applications available under sudo equivalent group$(tput sgr 0)"
    echo "------------------------------------------------------------------------------------------------------"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    export PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH
    if [ -f ${yum} ];
    then
        sudo yum group list development-tools | grep -q Installed; 
        if [ $? == 0 ];
        then
            echo "---------------------------------------------------------"
            echo "$(tput setaf 2)JARVIS: YUM detected Development-Tools.$(tput sgr 0)"
            echo "---------------------------------------------------------"
        else
            echo "--------------------------------------------------------"
            echo "$(tput setaf 3)JARVIS: Installing development-tools. $(tput sgr 0)"
            echo "--------------------------------------------------------"
            yum group install development-tools;
        fi
    else
        if [ $(dpkg-query -W -f='${Status}' build-essential 2>/dev/null | grep -c "ok installed") -eq 0 ];
        then
            sudo apt install build-essential;
        fi
    fi
fi

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Backup & Setup .bashrc.$(tput sgr 0)"
echo "---------------------------------------------------------"
if [ -e ${HOME}/.bashrc ];
then
    cp ${HOME}/.bashrc ${HOME}/bashrc.$(date +%d%H%M%b%y)
    # HOMEBREW FOR LINUX - $PATH
    echo '# HOMEBREW FOR LINUX - $PATH' >> ${HOME}/.bashrc
    echo 'PATH=/home/linuxbrew/.linuxbrew/bin:$PATH' >> ${HOME}/.bashrc
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.bashrc
    # RUBY - HOMEBREW FOR LINUX - $PATH
    echo '# RUBY - HOMEBREW FOR LINUX - $PATH' >> ${HOME}/.bashrc
    echo 'PATH=/home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >> ${HOME}/.bashrc
    # OHMYZSH
    echo 'export ZSH=${HOME}/.oh-my-zsh' >> ${HOME}/.bashrc
    . ~/.bashrc
fi

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing system packages.$(tput sgr 0)"
echo "---------------------------------------------------------"

packages=(
  "gcc"
  "git"
  "node"
  "ruby"
  "tmux"
  "neovim"
  "python3"
  "zsh"
  "ripgrep"
  "fzf"
  "zsh"
)

for i in "${packages[@]}"
do
  ${brew} install $i
  echo "---------------------------------------------------------"
done

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing Python NeoVim client.$(tput sgr 0)"
echo "---------------------------------------------------------"

pip3 install neovim

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing node neovim package$(tput sgr 0)"
echo "---------------------------------------------------------"

npm install -g neovim

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing spaceship prompt$(tput sgr 0)"
echo "---------------------------------------------------------"

npm install -g spaceship-prompt

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing vim linter (vint)$(tput sgr 0)"
echo "---------------------------------------------------------"

pip3 install vim-vint

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing bash language server$(tput sgr 0)"
echo "---------------------------------------------------------"

npm i -g bash-language-server

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing colorls$(tput sgr 0)"
echo "---------------------------------------------------------"

gem install colorls

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing system fonts.$(tput sgr 0)"
echo "---------------------------------------------------------"

#brew tap homebrew/cask-fonts            # doesn't work /w LinuxBrew; Error: Installing casks is supported only on macOS
#brew cask install font-hack-nerd-font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
cd ~/.local/share/fonts && curl -fLo "Hack Regular Nerd Font Complete Mono" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true"
cd ~/.local/share/fonts && curl -fLo "Hack Regular Nerd Font Complete" "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true"
fc-cache ~/.local/share/fonts
#fc-list | grep local.share.font

localGit="/home/linuxbrew/.linuxbrew/bin/git"
if ! [[ -f "$localGit" ]]; then
  echo "---------------------------------------------------------"
  echo "$(tput setaf 1)JARVIS: Invalid git installation. Aborting. Please install git.$(tput sgr 0)"
  echo "---------------------------------------------------------"
  exit 1
fi

# Create backup folder if it doesn't exist
mkdir -p ~/.local/share/nvim/backup

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing oh-my-zsh.$(tput sgr 0)"
echo "---------------------------------------------------------"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  npm install -g spaceship-prompt
else
  echo "---------------------------------------------------------"
  echo "$(tput setaf 2)JARVIS: oh-my-zsh already installed.$(tput sgr 0)"
  echo "---------------------------------------------------------"
fi

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing zsh-autosuggestions.$(tput sgr 0)"
echo "---------------------------------------------------------"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing vtop.$(tput sgr 0)"
echo "---------------------------------------------------------"
npm install -g vtop

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing Neovim plugins and linking dotfiles.$(tput sgr 0)"
echo "---------------------------------------------------------"

source install/backup.sh
source install/link.sh

nvim +PlugInstall +qall
nvim +UpdateRemotePlugins +qall
nvim -c 'CocInstall -sync coc-css coc-emmet coc-json coc-html|q'
nvim -c 'CocUpdateSync|q'


vim +PlugInstall +qall
vim +UpdateRemotePlugins +qall
vim -c 'CocInstall -sync coc-css coc-emmet coc-json coc-html coc-snippets coc-tslint-plugin coc-tsserver coc-ultisnips|q'
vim -c 'CocUpdateSync|q'     # :call coc#util#install()    #fixed error

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing Space vim-airline theme.$(tput sgr 0)"
echo "---------------------------------------------------------"

cp ~/.config/nvim/space.vim ~/.config/nvim/plugged/vim-airline-themes/autoload/airline/themes/space.vim

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Installing tmux plugin manager.$(tput sgr 0)"
echo "---------------------------------------------------------"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
fi

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Switching shell to zsh. You may need to logout.$(tput sgr 0)"
echo "---------------------------------------------------------"

sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: System update complete. Currently running at 100% power. Enjoy.$(tput sgr 0)"
echo "---------------------------------------------------------"

exit 0
