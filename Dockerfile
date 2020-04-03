FROM archlinux
LABEL maintainer="Marc Richter <mail@marc-richter.info>"

# Fix for "signature from "Anatol Pomozov <anatol.pomozov@gmail.com>" is unknown trust"
RUN rm -fr /etc/pacman.d/gnupg \
  && pacman-key --init \
  && pacman-key --populate archlinux \
  && pacman-key --refresh-keys

# Optimize mirror list by installing "reflector" and run it
RUN yes | pacman -Suyy \
  && pacman-db-upgrade \
  && yes | pacman -S reflector rsync \
  && cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
  && reflector -l 200 -p https --sort rate --save /etc/pacman.d/mirrorlist

# Update system to most recent state, fix possibly incorrect pacman db format after
# world upgrade, remove orphaned packages and clear pacman caches to have a smaller
# image
RUN yes | pacman -Su \
    && pacman-db-upgrade \
    && if [ ! -z "$(pacman -Qtdq)" ]; then \
      yes | pacman -Rns $(pacman -Qtdq) ; \
    fi \
    && yes | pacman -Scc \
    && pacman-optimize

# Housekeeping
RUN rm -f /etc/pacman.d/mirrorlist.pacnew
RUN mv -f /etc/systemd/coredump.conf.pacnew /etc/systemd/coredump.conf
RUN mv -f /etc/locale.gen.pacnew /etc/locale.gen

# Generate locales
RUN cat /etc/locale.gen | expand | sed 's/^# .*$//g' | sed 's/^#$//g' | egrep -v '^$' | sed 's/^#//g' > /tmp/locale.gen \
  && mv -f /tmp/locale.gen /etc/locale.gen \
  && locale-gen
