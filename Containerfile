ARG SOURCE_REGISTRY="${SOURCE_REGISTRY:-quay.io}"
ARG SOURCE_IMAGE="${IMAGE_NAME:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora-ostree-desktops}"

ARG IMAGE_REGISTRY="${SOURCE_REGISTRY}/${SOURCE_ORG}/${SOURCE_IMAGE}"
ARG IMAGE_VERSION="${IMAGE_VERSION:-41}"


FROM ${IMAGE_REGISTRY}:${IMAGE_VERSION} AS imc

LABEL org.opencontainers.image.description "Cloudvard's ImmutableCore Atomic OS"
LABEL org.opencontainers.image.url https://github.com/cloudvard/immutablecore
LABEL org.opencontainers.image.source https://github.com/cloudvard/immutablecore
LABEL org.opencontainers.image.vendor Cloudvard
LABEL org.opencontainers.image.authors Cloudvard
LABEL org.opencontainers.image.title "ImmutableCore Atomic OS"

ADD ./configs/ /

RUN dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y fish neovim aria2 lshw net-tools zstd fzf bat fd-find distrobox gnome-tweaks go
RUN dnf install -y code

RUN dnf group install -y multimedia
RUN dnf swap -y ffmpeg-free ffmpeg --allowerasing
RUN dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
RUN dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

RUN dnf install -y jetbrains-mono-fonts rsms-inter-fonts \
    google-go-mono-fonts fira-code-fonts mozilla-fira-sans-fonts
    
RUN dnf remove -y firefox firefox-langpacks gnome-shell-extension-background-logo

RUN dnf clean all

RUN systemctl disable flatpak-add-fedora-repos.service
RUN systemctl enable bootc-fetch-apply-updates.timer
RUN systemctl enable podman-auto-update.timer
RUN systemctl enable flatpak-system-update.timer
RUN systemctl enable flatpak-remove-fedora-repo.service
RUN systemctl --global enable flatpak-user-update.timer
RUN systemctl --global enable podman-auto-update.timer
RUN systemctl --global enable flatpak-add-flathub-repo.service

RUN rm -rf /tmp/* /var/* && \
    ostree container commit

FROM imc AS imc-pro

LABEL org.opencontainers.image.description "Cloudvard's ImmutableCore Atomic OS PRO Edition"
LABEL org.opencontainers.image.title "ImmutableCore Atomic OS Pro"

RUN dnf install -y cockpit-system cockpit-ostree cockpit-podman cockpit-bridge \
    cockpit-machines cockpit-networkmanager cockpit-selinux cockpit-storaged cockpit-files

RUN dnf install -y coreutils attr findutils hostname iproute glibc-common systemd nfs-utils samba-common-tools

RUN curl -sSL https://repo.45drives.com/setup | bash
RUN dnf install -y cockpit-file-sharing

RUN dnf clean all

RUN rm -rf /tmp/* /var/* && \
    ostree container commit