FROM quay.io/fedora/fedora-kinoite:latest AS imc-kde

ADD ./configs/ /

RUN rpm-ostree install bootc fish neovim flatpak flatpak-spawn \ 
    distrobox aria2 libratbag-ratbagd lshw net-tools zstd fzf \
    bat fd-find kio-admin kate

RUN rpm-ostree install code jetbrains-mono-fonts fira-code-fonts
RUN rpm-ostree override remove plasma-discover-rpm-ostree

RUN systemctl disable flatpak-add-fedora-repos.service
RUN systemctl enable bootc-fetch-apply-updates.timer
RUN systemctl enable podman-auto-update.timer   
RUN systemctl enable flatpak-system-update.timer
RUN systemctl --global enable flatpak-user-update.timer

RUN rm -f /etc/yum.repos.d/vscode.repo && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp