FROM archlinux
LABEL maintainer="Marc Richter <mail@marc-richter.info>"

# https://www.archlinux.org/news/gnupg-21-and-the-pacman-keyring/
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
    && yes | pacman -Scc

# Housekeeping
RUN [[ -f /etc/pacman.d/mirrorlist.pacnew ]] && rm -f /etc/pacman.d/mirrorlist.pacnew
RUN for file in $(find /etc -name '*.pacnew'); do \
    mv -fv ${file} $(echo ${file} | sed 's#\.pacnew##g'); done

# (Re-)install glibc, to fix some things (like missing i18n definition files at
# /usr/share/i18n/locales)
RUN yes | pacman -Sy \
  && yes | pacman -S glibc \
  && yes | pacman -Scc

# Generate locales
COPY files/locale.gen /etc/locale.gen
RUN cat /etc/locale.gen | expand | sed 's/^# .*$//g' | sed 's/^#$//g' | egrep -v '^$' | sed 's/^#//g' > /tmp/locale.gen \
  && mv -f /tmp/locale.gen /etc/locale.gen \
  && locale-gen
