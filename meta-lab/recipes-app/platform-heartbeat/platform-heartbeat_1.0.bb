DESCRIPTION = "Boot-time heartbeat report for the lab platform"
MAINTAINER = "Arman Soroushmehr <armansoroush@gmail.com>"

DEBIAN_DEPENDS = "systemd"

SRC_URI = " \
    file://platform-heartbeat.sh \
    file://platform-heartbeat.service \
"

inherit dpkg-raw

do_install() {
    install -d -m 755 ${D}/usr/bin
    install -m 755 ${WORKDIR}/platform-heartbeat.sh ${D}/usr/bin/platform-heartbeat

    install -d -m 755 ${D}/etc
    echo "LAB_PLATFORM_VERSION=${PV}" > ${D}/etc/lab-release
}