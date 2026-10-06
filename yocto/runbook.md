# Yocto lab — runbook

Exact commands used to run the experiment on this Mac. Run them in order.

## 0. Host-side check (macOS, read-only)

```sh
uname -m                 # arm64
sysctl -n hw.memsize     # RAM
df -h /                  # free disk
colima status            # is the Linux VM up?
```

## 1. Linux VM (colima)

The VM already exists. To bring it up (only if `colima status` says it is not running):

```sh
colima start --arch aarch64 --cpu 4 --memory 8 --disk 25
docker info --format '{{.OperatingSystem}} {{.Architecture}}'
```

## 2. Ubuntu container with Yocto build-host packages

```sh
docker run -it --name yocto-lab \
  -v yocto-lab-src:/src \
  ubuntu:24.04 bash
```

Inside the container:

```sh
apt-get update && apt-get install -y --no-install-recommends \
  build-essential chrpath cpio debianutils diffstat file gawk gcc git \
  iputils-ping libacl1 libcrypt-dev locales python3 python3-git \
  python3-jinja2 python3-pexpect python3-pip python3-subunit socat \
  texinfo unzip wget xz-utils zstd lz4 ca-certificates

# en_US.UTF-8 locale (Yocto requires it).
# NOTE: Ubuntu ships the en_US.UTF-8 line *commented out*, so a naive
# `grep -q` matches the comment and skips generation. Uncomment it explicitly:
sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
locale -a | grep -i en_US      # must list en_US.utf8
export LANG=en_US.UTF-8

# BitBake refuses to run as root — create a normal user and use it for builds.
useradd -m -s /bin/bash builder
chown -R builder:builder /src
```

Then run build steps as that user (note `-u builder`):

```sh
docker exec -u builder -e HOME=/home/builder -e LANG=en_US.UTF-8 yocto-lab bash -lc '...'
```

## 3. Get Poky (shallow clone to save disk)

```sh
cd /src
git clone --depth 1 -b scarthgap https://git.yoctoproject.org/poky
cd poky
source oe-init-build-env
```

## 4. First build — one small recipe (watch disk)

```sh
bitbake zlib
du -sh /src/poky/build/tmp
df -h /                      # how much did it eat?
```

`zlib` goes through the full pipeline (fetch → configure → compile → package)
but is tiny, which makes it the cheapest way to prove the toolchain works.

## 5. Full image (only if disk allows)

A real image needs ~20-40 GB; the VM had 17 GB free, so this is a stretch:

```sh
bitbake core-image-minimal
ls -lh tmp/deploy/images/qemuarm64/
```

`MACHINE` defaults to `qemux86-64` via `MACHINE ??= "qemux86-64"` in `local.conf`
(that line is *already uncommented*, so "append if absent" checks wrongly skip
setting it). To target the native arm64 arch (faster) append a hard assignment:

```
MACHINE = "qemuarm64"
```

## 6. Boot it

```sh
runqemu qemuarm64 nographic
```

Caveat: nested virtualization inside colima normally has **no KVM**, so QEMU
falls back to TCG (slow but functional). Fallback: copy `Image` + rootfs out of
the container and run `qemu-system-aarch64` directly on the Mac.

## Cleanup

```sh
docker rm -f yocto-lab
docker volume rm yocto-lab-src
```

Do **not** `colima delete` — that VM predates this experiment.
