FROM quay.io/fedora/fedora-bootc:latest AS imc-main

RUN dnf -y upgrade --refresh
RUN dnf -y install fish neovim flatpak flatpak-spawn distrobox aria2 libratbag-ratbagd lshw net-tools zstd fzf bat fd-find
RUN dnf -y install jetbrains-mono-fonts

ADD ./configs/usr/ /usr/

RUN systemctl disable flatpak-add-fedora-repos.service
RUN systemctl enable bootc-fetch-apply-updates.timer
RUN systemctl enable podman-auto-update.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

RUN chsh -s /usr/bin/fish root

FROM imc-main AS imc-gnome
RUN dnf -y group install "Fedora Workstation" --exclude=rootfiles,firefox,firefox-langpacks,gnome-terminal,gnome-terminal-nautilus,gnome-shell-extension-background-logo
RUN dnf -y install gnome-console
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
RUN dnf -y check-update
RUN dnf -y install code
# RUN dnf -y groupinstall "KDE Plasma Workspaces"