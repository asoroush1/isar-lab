DESCRIPTION = "Lab platform image"

LICENSE = "gpl-2.0"
LIC_FILES_CHKSUM = "file://${LAYERDIR_core}/licenses/COPYING.GPLv2;md5=751419260aa954499f7abaabaa882bbe"

PV = "1.0"

inherit image

# From Debian's repositories
IMAGE_PREINSTALL += "openssh-server htop curl less"

# Built by ISAR from recipes
IMAGE_INSTALL += "platform-heartbeat sshd-regen-keys"

# Custom disk layout — only for the x86-64 machine, which builds a wic image
WKS_FILE:qemuamd64 = "lab-efi"