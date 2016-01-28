FROM base/archlinux
MAINTAINER Marc Richter <mail@marc-richter.info>

# Fix for "signature from "Anatol Pomozov <anatol.pomozov@gmail.com>" is unknown trust"
RUN pacman-key --populate archlinux \
  && pacman-key --refresh-keys

# Optimize mirror list
RUN yes | pacman -Suyy \
  && pacman-db-upgrade \
  && yes | pacman -S reflector rsync \
  && cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
  && reflector -l 200 -p https --sort rate --save /etc/pacman.d/mirrorlist

# Remove reflector and it's prerequirements
RUN yes | pacman -Rsn reflector python rsync

# Update system to most recent
RUN yes | pacman -Su

# Fix possibly incorrect pacman db format after world upgrade
RUN pacman-db-upgrade

# Remove orphaned packages
RUN if [ ! -z "$(pacman -Qtdq)" ]; then \
    yes | pacman -Rns $(pacman -Qtdq) ; \
  fi

# Clear pacman caches
RUN yes | pacman -Scc

# Optimize pacman database
RUN pacman-optimize
