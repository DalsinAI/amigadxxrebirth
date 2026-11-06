#!/bin/sh
# Descent2's release archive alone, for Cradle's stove_build (target
# package/descent2): package/build-amiga.sh with GAMES=Descent2. MIT, Copyright (c)
# 2026 AmiCradle Team.
set -eu
GAMES=Descent2 exec sh "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)/build-amiga.sh"
