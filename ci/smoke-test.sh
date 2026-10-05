#!/usr/bin/env bash
# Boot an ISAR qemuamd64 image headless and wait for the heartbeat on the serial console.
# Usage: smoke-test.sh <image.wic> [boot.log]
set -euo pipefail

IMAGE="${1:?usage: smoke-test.sh <image.wic> [boot.log]}"
LOG="${2:-boot.log}"
TIMEOUT="${TIMEOUT:-600}"
MARKER="PLATFORM-HEARTBEAT"
OVMF="${OVMF:-/usr/share/ovmf/OVMF.fd}"

KVM_ARGS=""
if [ -w /dev/kvm ]; then
    KVM_ARGS="-enable-kvm -cpu host"
fi

rm -f "$LOG"
qemu-system-x86_64 $KVM_ARGS -m 1024M -M q35 \
    -bios "$OVMF" \
    -hda "$IMAGE" \
    -snapshot -display none -monitor none \
    -serial file:"$LOG" &
QEMU_PID=$!
trap 'kill "$QEMU_PID" 2>/dev/null || true' EXIT

for ((waited = 0; waited < TIMEOUT; waited += 5)); do
    if grep -q "$MARKER" "$LOG" 2>/dev/null; then
        echo "PASS: '$MARKER' seen after ~${waited}s"
        grep "$MARKER" "$LOG"
        exit 0
    fi
    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
        echo "FAIL: QEMU exited before the marker appeared"
        tail -n 50 "$LOG" || true
        exit 1
    fi
    sleep 5
done

echo "FAIL: '$MARKER' not seen within ${TIMEOUT}s"
tail -n 50 "$LOG" || true
exit 1