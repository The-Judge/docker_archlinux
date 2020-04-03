# About this Image

## Initial motivation for this image

A few years ago, the situation for the [Arch Linux] [official base image] was quite bad;
updates did come very sparse and whoever pulled the [Arch Linux] Docker image had to apply
months of past sysupdates prior to make productive use of it.

This image adds the following improvements to this:

1. Mirrorlist is updated using [reflector](https://wiki.archlinux.org/index.php/Reflector).
2. It's an automated build, triggered daily to make sure latest updates are always available
without any manual interaction needed. Also it is triggered by updates to the [official base image]
and updates in the GitRepo.
3. A full system update is installed during these (at least) daily builds. Orphaned packages are
removed (as described in [System maintenance wiki site](https://wiki.archlinux.org/index.php/System_maintenance), regarding [Remove orphaned packages](https://wiki.archlinux.org/index.php/System_maintenance#Remove_orphaned_packages)).
4. Pacman database is optimized.
5. GPG keys are refreshed.

[Arch Linux]: https://www.archlinux.org
[official base image]: https://registry.hub.docker.com/_/archlinux
