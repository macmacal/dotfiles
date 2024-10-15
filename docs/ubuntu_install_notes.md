## Install programs
DO NOT INSTALL 3rd PARTY DRIVERS DURING THE OS INSTALLATION!


### From repos
```bash
sudo apt upgrade && sudo apt install \
bat \
checkinstall \
chromium-browser \
cmake \
curl \
fd-find \
firefox \
flameshot \
fzf \
gcc \
git \
htop \
keepassxc \
libreoffice \
mc \
mupdf \
ncdu \
neofetch \
neovim \
nmap \
pv \
python3-pip \
ranger \
rclone \
ssh \
thunderbird \
tmux \
tree \
xdotool \
zsh \
```

```bash
sudo apt install build-essential \
ca-certificates \
clang \
clang-format \
clang-tidy \
cmake \
curl \
python3-dev \
python3-pip
apt update && apt install -y $(eval echo $(cat  < requirements_base_apt.txt))
pip3 install -r requirements_base_pip.txt
```

### Manually


* Zotero
    * https://www.zotero.org/download/ -> `https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=6.0.4`
    * unpack to `/opt/zotero`
    * then:
    ```bash
    cd /opt/zotero
    sudo ./set_launcher_icon
    mkdir -p ~/.local/share/applications/
    ln -s /opt/zotero/zotero.desktop ~/.local/share/applications/zotero.desktop
    ```
* Fonts
    * FiraCode NerdFont
    * zip file `https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip`
    * installing per user:
        ```bash
        mkdir ~/.fonts
        <copy all fonts hir>
        ```
    * installing system-wide
        ```bash
        sudo cp *.ttf /usr/share/fonts/truetype/
        sudo cp *.otf /usr/share/fonts/opentype/
        ```
* kitty terminal
    * kity terminal dropdown script dependencies
    ```bash
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    sudo ln -s /home/$USER/.local/kitty.app/bin/kitty /bin/kitty
    ```
* oh-my-zsh
    * `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
    * change default shell -> `chsh -s /bin/zsh $USER`
* GPU drivers
    * nvidia-driver, cuda
    * `sudo apt install nvidia-driver-$NEWEST nvidia-dkms-$NEWEST`
* Docker
    * docker-cuda-toolkit
* MS Teams
    * `https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0x415&culture=pl-pl&country=PL`
* ROS2
    * see script below
* IDEs
    * Visual Studio Code `https://code.visualstudio.com/docs/?dv=linux64_deb`
    * CLion `sudo snap install clion --classic`
    * Pycharm Community `sudo snap install pycharm-community --classic`
* Onlykey SSH agent
    ```bash
    # for reqs only
    sudo apt update && sudo apt upgrade
    sudo apt install -y python3-pip python3-tk libusb-1.0-0-dev libudev-dev
    sudo pip3 install onlykey-agent
    wget https://raw.githubusercontent.com/trustcrypto/trustcrypto.github.io/master/49-onlykey.rules
    sudo cp 49-onlykey.rules /etc/udev/rules.d/
    sudo udevadm control --reload-rules && udevadm trigger
    ```
    IF DOESN'T WORK, CHECK THIS `https://github.com/trustcrypto/onlykey-agent`

* Python3 neovim integration
    * `sudo pip3 install pynvim`
* Refersh neofetch pciids
    * `sudo update-pciids`

* NeoVIM Plugin manager
    * `https://github.com/junegunn/vim-plug`
    * `sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'`
    * Run nvim -> :PluginUpdate



## Configure

* Restore backup
* ssh
    * ~/.ssh/config
    * `sudo systemctl enable ssh`
* /etc/hosts
* ~/.zshrc_local
* DE global shortcuts
    * flameshot `flameshot gui`
    * dropdown terminal `~/.scripts/SCRIPT.zsh`
* DE visuals
    * wallpapers
* FZF bindings
* Okular layout
* Configure clouds for rclone
* IDEs configs:
    * VSC, PyCharm, Clion
    * or copy them from previous computer

## Programs to configure
* Zotero
* Thunderbird
* Firefox

## TODO
* Script for automatic verification of checksums
* Fix Kitty-dropdown for vertical monitors
    * Fixed by KDE auto window settings
* Fix kitty-dropdown monitor selection (KDE window focus) - somehow works on arch
    * Fixed by toying with Window Behavior activation policy
* Fix sudo mc in kitty (doesn't accept arrows keys)
* Fix fzf config for ubuntu
* Add Okular to .dotfiles

## DOCKER INSTALL
```bash
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker
sudo usermod -aG docker $USER
```

OR

```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
sudo usermod -aG docker $USER
```

## NVIDIA DOCKER

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add - \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## CUDA toolkit

### 11.0.0
``bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pinsudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda-repo-ubuntu2004-11-0-local_11.0.2-450.51.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-0-local_11.0.2-450.51.05-1_amd64.debsudo apt-key add /var/cuda-repo-ubuntu2004-11-0-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
```
## ROS2 install

### Colcon

```bash
sudo sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install -y python3-colcon-common-extensions
```

### ROS2 Foxy
```bash
sudo apt update && sudo apt install curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update
sudo apt install ros-foxy-ros-base

```
