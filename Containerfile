FROM quay.io/fedora-ostree-desktops/base-atomic:41 AS imc-core

ADD ./configs/ /

RUN dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y fish neovim aria2 lshw net-tools zstd fzf bat fd-find distrobox gnome-tweaks
RUN dnf install -y code

RUN dnf group install -y multimedia
RUN dnf swap -y ffmpeg-free ffmpeg --allowerasing
RUN dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
RUN dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

RUN dnf install -y jetbrains-mono-fonts-all rsms-inter-fonts \
    google-go-mono-fonts google-droid-sans-mono-fonts \
    fira-code-fonts mozilla-fira-sans-fonts powerline-fonts
    
RUN dnf remove -y firefox firefox-langpacks gnome-shell-extension-background-logo

RUN systemctl disable flatpak-add-fedora-repos.service
RUN systemctl enable bootc-fetch-apply-updates.timer
RUN systemctl enable podman-auto-update.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

# RUN ostree container commit

# RUN rm -rf /tmp/* /var/* && \
#     ostree container commit
