#!/bin/sh
# The release archives, for Cradle's stove_build (target package): both
# games built with amiga/Makefile.amigaos on acsdl12 and acgame.library
# (fetched and built at pinned commits by package/acgame-deps.sh), then
# tools/make_package.py makes descent-VERSION-68040.lha and
# descent2-VERSION-68040.lha, each with its .sha256 and .readme: the
# Descent (or Descent2) drawer as the Makefile makes it, with the
# acgame.library it was built against in Libs/, its icon, and beside them
# the Amiga Installer script Install-Descent (Install-Descent2) and its
# icon (package/installer/, made by amicradle scripts/port_installer.py
# from package/descent-installer.json and descent2-installer.json). OUT
# also gets each drawer as it unpacks, as Descent.tar and Descent2.tar
# (for a lab), and their package.json.
# VERSION is package/VERSION. Nothing is published from here.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
OUT=${OUT:-"$ROOT/build-amiga-package"}
VERSION=$(cat "$HERE/VERSION")
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
BUILD=$(mktemp -d "${TMPDIR:-/tmp}/descent-package.XXXXXX")
trap 'rm -rf "$BUILD"' EXIT INT TERM
cd "$ROOT"

ACSDL12=1
. "$HERE/acgame-deps.sh"

# GAMES picks which: both by default; package/descent and package/descent2
# build one each, as one build of both takes longer than a stove_build may.
GAMES=${GAMES:-"Descent Descent2"}
TARGETS=
for drawer in $GAMES; do
	case $drawer in
	Descent) TARGETS="$TARGETS d1x" ;;
	Descent2) TARGETS="$TARGETS d2x" ;;
	*) echo "GAMES: no game $drawer" >&2; exit 1 ;;
	esac
done
make -f amiga/Makefile.amigaos STOVE="$STOVE" NDK="$NDK" ACGAME="$ACGAME" ACGAMELIB="$ACGAMELIB" ACSDL="$ACSDL" ACSDLLIB="$ACSDLLIB" -j4 $TARGETS > "$OUT/build-output.txt" 2>&1 || { tail -n 60 "$OUT/build-output.txt"; exit 1; }

# For each game: the program, checked by its SHA-256, the rest of the
# drawer as a tar, and what the ReadMe and the check name (the program's
# SHA-256, the commit, the compiler, the commit's date for the archive's
# dates, and the acgame.library it ships).
for drawer in $GAMES; do
	spec=$(echo "$drawer" | tr A-Z a-z)
	B="$BUILD/$drawer"
	mkdir -p "$B"
	cp "build/amigaos/$drawer/$drawer" "$B/$drawer"
	cp "$BUILD/acgame.library" "$B/acgame.library"
	python3 - "build/amigaos/$drawer" "$drawer" "$B/drawer.tar" <<'PY'
import sys, tarfile
from pathlib import Path
drawer, exe, out = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
with tarfile.open(out, "w", format=tarfile.USTAR_FORMAT) as t:
    for p in sorted(drawer.rglob("*")):
        rel = p.relative_to(drawer).as_posix()
        if p.is_file() and rel != exe:
            info = tarfile.TarInfo(rel)
            info.size, info.mode = p.stat().st_size, 0o644
            with p.open("rb") as f:
                t.addfile(info, f)
PY
	python3 - "$B" "$STOVE/bin/m68k-amigaos-gcc" "$drawer" "$ACGAME_COMMIT" <<'PY'
import hashlib, json, subprocess, sys
from pathlib import Path
build, cc, exe, acgame = Path(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4]
git = lambda *a: subprocess.run(["git", *a], capture_output=True, text=True).stdout.strip()
receipt = {
    "executable_sha256": hashlib.sha256((build / exe).read_bytes()).hexdigest(),
    "source_commit": git("rev-parse", "HEAD"),
    "compiler_release": subprocess.run([cc, "--version"], capture_output=True,
                                       text=True).stdout.splitlines()[0],
    "source_date_epoch": int(git("log", "-1", "--format=%ct") or 0),
    "acgame_commit": acgame,
    "acgame_library_sha256": hashlib.sha256((build / "acgame.library").read_bytes()).hexdigest(),
}
(build / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
PY
	cp "$B/receipt.json" "$OUT/receipt-$spec.json"
	python3 "$ROOT/tools/make_package.py" --spec "$HERE/$spec.json" --build "$B" --version "$VERSION" --out "$OUT"
	mv "$OUT/package.json" "$OUT/package-$spec.json"
done
