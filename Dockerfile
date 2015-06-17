FROM base/archlinux
MAINTAINER Marc Richter <mail@marc-richter.info>

# Optimize mirror list
RUN yes | pacman -S reflector \
  && cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
  && reflector -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

# Update system to most recent
RUN yes | pacman -Suy

# Remove orphaned packages
ADD helpers/remove_orphaned_packages.sh /tmp/
RUN chmod +x /tmp/remove_orphaned_packages.sh \
  && /tmp/remove_orphaned_packages.sh \
  && rm -f /tmp/remove_orphaned_packages.sh

# Clear pacman caches
RUN pacman -Scc

# Optimize pacman database
RUN pacman-optimize
