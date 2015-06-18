# About this Image #

This is a minimal [Arch Linux](https://www.archlinux.org/) image, based upon the
[official base image](https://registry.hub.docker.com/u/base/archlinux/), without any additional packages installed.
Unfortunately, this official base image is not very well maintained when it comes to regular updates to improve overall
security.

This image adds the following improvements to this:

1. Mirrorlist is updated using [reflector](https://wiki.archlinux.org/index.php/Reflector). The tool is removed
afterwards to keep the image clean.
2. It's an automated build, triggered daily to make sure latest updates are available.
3. A full system update is installed. Orphaned packages are removed (as described in
[System maintenance wiki site](https://wiki.archlinux.org/index.php/System_maintenance), regarding
[Remove orphaned packages](https://wiki.archlinux.org/index.php/System_maintenance#Remove_orphaned_packages)).
4. Pacman database is optimized.
5. GPG keys are refreshed.
