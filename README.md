# ISAR Learning Lab

This is a personal learning lab I built to understand the [ISAR](https://github.com/ilbers/isar) image generation system, specifically focusing on reproducible builds, custom layers, and SBOM generation for embedded Linux platforms.

### ⚠️ Security Note regarding `lab.yml`
In `lab.yml`, there is a `local_conf_header` block that hardcodes the root password to `root` in clear text. 

**This is strictly for local QEMU testing in this learning lab.** In a real production environment, this block would be removed entirely. Instead, access would be managed without passwords using SSH keys (such as the `sshd-regen-keys` package included in this image) and unique per-device provisioning.