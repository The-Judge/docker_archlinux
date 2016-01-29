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

# Housekeeping
RUN rm -f /etc/pacman.d/mirrorlist.pacnew
RUN mv -f /etc/systemd/coredump.conf.pacnew /etc/systemd/coredump.conf
RUN mv -f /etc/locale.gen.pacnew /etc/locale.gen

# Generate locales
RUN cat /etc/locale.gen | expand | sed 's/^# .*$//g' | sed 's/^#$//g' | egrep -v '^$' | sed 's/^#//g' > /tmp/locale.gen \
  && mv -f /tmp/locale.gen /etc/locale.gen \
  && locale-gen

