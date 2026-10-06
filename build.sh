#!/usr/bin/env bash
# Usage: ./build.sh [breeze-version e.g. 6.5.3] [--prepare-only]
# Defaults to the version of the installed kdecoration package.
set -euo pipefail
cd "$(dirname "$0")"
VER="${1:-}"
if [[ -z "$VER" || "$VER" == --* ]]; then
  VER=$(pacman -Q kdecoration | awk '{print $2}' | sed -E 's/^[0-9]+://; s/-[0-9]+$//')
fi
echo "==> Breeze v$VER"
rm -rf src && mkdir src
git clone -q --depth 1 --branch "v$VER" https://github.com/KDE/breeze.git upstream
cp -r upstream/kdecoration src/kdecoration
cp -r upstream/libbreezecommon src/libbreezecommon
rm -rf upstream src/kdecoration/config src/kdecoration/CMakeLists.txt
cp kdecoration.cmake src/kdecoration/CMakeLists.txt
cp CMakeLists.txt src/CMakeLists.txt
python3 patch.py src/kdecoration
[[ " $* " == *" --prepare-only "* ]] && exit 0
cmake -S src -B src/build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build src/build -j"$(nproc)"
sudo cmake --install src/build
echo "==> Done. Select 'Breeze Win' in Window Decorations."
