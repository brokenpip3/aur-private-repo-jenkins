# Var

ARG REPONAME
ARG REPOURL
ARG PKGDEST='/srv/repo'
ARG GPGOPT='keyserver-options auto-key-retrieve'

# Builder

FROM archlinux:base-devel as BUILDER
ARG PKGDEST
ARG GPGOPT
RUN printf "PKGDEST=${PKGDEST}\n" >> /etc/makepkg.conf \
   && pacman -Sy archlinux-keyring --noconfirm --noprogressbar && pacman -Syyu --needed --noconfirm --noprogressbar git base-devel \
   && pacman -Sc --noconfirm
RUN useradd --create-home --shell /bin/bash makepkg && touch /etc/sudoers.d/makepkg \
   && printf "makepkg ALL=(ALL) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman\n" > /etc/sudoers.d/makepkg && mkdir /build \
   && mkdir /home/makepkg/.gnupg /srv/repo && chown makepkg:makepkg /home/makepkg/.gnupg /build /srv/repo
USER makepkg
WORKDIR /build
RUN printf "${GPGOPT}\n" >> /home/makepkg/.gnupg/gpg.conf \
   && git clone https://aur.archlinux.org/aurutils.git && cd aurutils; makepkg -sic --noconfirm;

# Main

FROM archlinux:base-devel
ARG REPONAME
ARG REPOURL
ARG PKGDEST
ARG GPGOPT
COPY --from=BUILDER /srv/repo/*.pkg.tar.zst /tmp/
COPY entrypoint.sh /
RUN printf "PKGDEST=${PKGDEST}\n" >> /etc/makepkg.conf
RUN pacman -Sy archlinux-keyring --noconfirm --noprogressbar && pacman -Syyu --needed --noconfirm --noprogressbar icu base-devel jq \
   && pacman -U /tmp/*.pkg.tar.zst --noconfirm && pacman -Sc --noconfirm
RUN useradd --create-home --shell /bin/bash makepkg && touch /etc/sudoers.d/makepkg /home/makepkg/mypersonalrepo.conf \
   && printf "makepkg ALL=(ALL) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman\n" > /etc/sudoers.d/makepkg \
   && ln -s /home/makepkg/mypersonalrepo.conf /etc/pacman.d/mypersonalrepo.conf \
   && mkdir /build /home/makepkg/.gnupg \
   && chown makepkg:makepkg /home/makepkg/ /build /etc/pacman.d/mypersonalrepo.conf /home/makepkg/.gnupg \
   && printf "${GPGOPT}\n" >> /home/makepkg/.gnupg/gpg.conf \
   && printf "Include = /etc/pacman.d/mypersonalrepo.conf\n" >> /etc/pacman.conf
COPY --chown=makepkg:makepkg mypersonalrepo.conf /home/makepkg/
USER makepkg
WORKDIR /build
ENTRYPOINT ["/entrypoint.sh"]
