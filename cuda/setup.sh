#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export MINICONDA_VERSION=latest
export MINICONDA_PATH=/opt/miniconda
export USERNAME=user
export USER_UID=1000

sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

apt update
apt upgrade -y
apt install -y --no-install-recommends curl wget git sudo neovim tmux less ssh zsh zsh-syntax-highlighting zsh-autosuggestions
rm -rf /var/lib/apt/lists/*

curl -s -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
bash miniconda.sh -b -p ${MINICONDA_PATH}
rm miniconda.sh

userdel -rf ubuntu || true
useradd -m ${USERNAME} --uid=${USER_UID}
usermod -aG sudo ${USERNAME}
echo 'user:password' | chpasswd
echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/${USERNAME}
chsh -s /bin/bash ${USERNAME}
chown -R ${USERNAME}:${USERNAME} ${MINICONDA_PATH}
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

sudo -u user sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
    sudo -u user git clone --branch 24.09.04 https://github.com/marlonrichert/zsh-autocomplete.git /home/user/.oh-my-zsh/custom/plugins/zsh-autocomplete &&
    sudo -u user mv /home/user/.zshrc.pre-oh-my-zsh /home/user/.zshrc
