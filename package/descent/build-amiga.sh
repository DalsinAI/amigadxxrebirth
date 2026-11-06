#!/bin/sh
# Descent's release archive alone, for Cradle's stove_build (target
# package/descent): package/build-amiga.sh with GAMES=Descent. MIT, Copyright (c)
# 2026 AmiCradle Team.
set -eu
GAMES=Descent exec sh "$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)/build-amiga.sh"
