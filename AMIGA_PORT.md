D1X-Rebirth and D2X-Rebirth for AmigaOS 3.x
===========================================

These are DXX-Rebirth's Descent 1 and Descent 2 engines (D1X-Rebirth,
the Descent program, and D2X-Rebirth, the Descent2 program) for
AmigaOS 3.x on a 68040 or 68060 with FPU, drawn with DXX's own software
renderer on an 8-bit screen (AGA or RTG) through acsdl12, the AmiCradle
Team's SDL 1.2. Each game has its own drawer.

Upstream: https://github.com/dxx-rebirth/dxx-rebirth, revision
6943b924bea749543ef5729f31a28345e79716d2 (master of 2026-10-11).

Installing
----------

Each game comes in its own archive (descent-...lha, descent2-...lha).
Unpack it anywhere (on AmiCradle: SYS:Utilities/OpenCompress x
descent-...lha RAM:), then double-click Install-Descent (Install-Descent2)
beside the drawer: it asks where to put the game (Work:Games by default)
and keeps the Data drawer of an earlier install, game data and all.
Pilots, saved games and settings are not in the archive, so an update
leaves them as they are. Each drawer's Libs holds the acgame.library the
game was built against, and the game opens that copy first.

Running it
----------

1. Put descent.hog and descent.pig from Descent 1 (the freely
   distributable shareware 1.4, or the full game 1.4/1.5) into the Data
   drawer. See Data/ReadMe. No game data comes with this port.
2. Double-click Descent. The icon asks for a 512 KB stack; from a Shell,
   "Stack 524288" first.

Descent 2 is the same in the Descent2 drawer: put descent2.hog,
descent2.ham and the .pig files of the full game (1.2), or d2demo.hog,
d2demo.ham and d2demo.pig of the demo, into its Data drawer (see its
Data/ReadMe), and double-click Descent2. The full game's movies (*.mvl)
go there too and play through libmve; the demo has none. d2x.ini takes
its options.

Settings (descent.cfg), pilots, saved games, demos and screenshots are
written to the program's drawer (PROGDIR:). The screen opens at 320x200;
other sizes can be picked in Options > Graphics, at a cost in speed.
d1x.ini in the Descent drawer takes command-line options, as upstream.

What this build leaves out
--------------------------

- Music. Descent's music is HMP (MIDI); acsdl12 plays no MIDI, and its
  SDL_mixer subset is not used (sdlmixer=0), so there is no music and no
  external OGG/MP3 music. CD audio is out too (acsdl12 has no SDL_CD).
  Sound effects play: they come from descent.pig (descent2.s11/s22 or
  the pig in Descent 2) through DXX's own mixer (digi_audio.cpp) on
  SDL_OpenAudio. Descent 2's movie sound plays through libmve on the same
  audio, with the movie audio ring guarded by the sound lock.
- Network games. There is no UDP stack in this build, so Multiplayer has
  nothing to start or join; the multiplayer code is built with an empty
  protocol (amiga/multi_none.cpp).
- OpenGL, the level editor, PNG screenshots (screenshots are PCX).
- Keys the Amiga does not have (Home, End, Page Up/Down, Insert, Pause,
  F11, F12) cannot be bound.

Known issues
------------

- Esc does nothing during a game. Right Amiga+Q brings up "Abort game?"
  (and on the menus, the quit question) instead.
- Descent 2's movies need the full game's CD data (the *.mvl files); the
  demo has none, so the Descent 2 intro movie is untested in the lab.
  Descent 1 (shareware 1.0 and 1.4) has been played in the lab.

Building
--------

    make -f amiga/Makefile.amigaos -j2          # both games
    make -f amiga/Makefile.amigaos -j2 d1x      # Descent only
    make -f amiga/Makefile.amigaos -j2 d2x      # Descent2 only

The defaults find GFOpenAmigaGCC 16.2.0-open4 (STOVE), the NDK, acsdl12
and ACGame under $HOME/CradleLab; override STOVE=, NDK=, ACSDL=,
ACSDLLIB=, ACGAME=, ACGAMELIB= as needed. acsdl12 is built without its own
ACGame (ACG=), and the games link acgame.library's stubs (libacgame.a).
package/build-amiga.sh (STOVE and OUT set) makes both release archives
with their installers; it fetches and builds acgame, acsdl12 and zlib at
pinned commits. The output is build/amigaos/Descent/ with Descent.info beside
it, and build/amigaos/Descent2/ with Descent2.info. Each C++ file needs several hundred MB to compile; on a small machine
use -j1 or -j2.

Upstream builds with SCons. amiga/Makefile.amigaos builds the sources
SConstruct picks for

    scons d1x=1 d2x=1 opengl=0 sdl2=0 sdlmixer=0 sdlimage=0 use_udp=0
          editor=0 host_endian=big screenshot=legacy

with SConstruct's own warning flags, and amiga/dxxsconf.h is the header
SConstruct's tests wrote when run with this compiler (see its comment for
what differs). The kconfig table is made with upstream's
generate-kconfig-udlr.py, as SCons does.

PhysicsFS
---------

PhysicsFS 3.2.0 is LIBS:physfs.library (DalsinAI/gfopenphysfs, zlib
licence), one copy for every port on the machine, not a copy built into
the program. GFOpenUp installs it; otherwise copy physfs.library into
LIBS:. The game opens it at start (libphysfs_auto) and says so if it is
missing. Its AmigaOS platform layer is the one this port had built in:
AmigaDOS names, in which a trailing "/" means the parent drawer, are
tidied before they are opened; the base, user and pref dirs are all
PROGDIR:. HOG files and Descent 2's MVL movie libraries read as before.
Zip members that are deflated (some add-on missions) inflate through
LIBS:z.library, which GFOpenUp also installs.

Changes to DXX-Rebirth
----------------------

- similar/arch/sdl/gr.cpp: the screen gets the canvas's palette as well,
  so the per-frame blit is a copy (acsdl12's screens are 8-bit); and
  gr_palette_load() takes the const palette its declaration says (the
  SDL software renderer no longer linked upstream).
- d2x-rebirth/libmve/mveplay.cpp: a struct timeval is zeroed with {},
  as libnix's timeval holds unions.
- similar/misc/args.cpp: 8 bits per pixel by default on AmigaOS.
- similar/main/game.cpp, config.cpp: 320x200 by default on AmigaOS.
- common/main/net_udp.h, similar/main/multi.cpp, amiga/multi_none.cpp:
  upstream's use_udp=0 (no multiplayer) build no longer compiles at any
  recent revision, so this port builds the multiplayer code
  (DXX_USE_MULTIPLAYER 1) without UDP: net_udp.h's UDP parts are under
  #if DXX_USE_UDP, two UDP-only spots in multi.cpp likewise, and an
  empty protocol table stands in for UDP's.
- similar/main/songs.cpp: an unused parameter in the no-mixer,
  no-CD build is marked [[maybe_unused]].
- Big-endian fixes, see below.
- amiga/amiga_prefix.h (included first everywhere) undoes the
  toolchain pthread.h's close()/read()/open() wrapper macros, which also
  rewrite SDL_RWops's ctx->close(); amiga/sdl12_extra.h has the SDL 1.2
  names acsdl12 lacks (SDLK_WORLD_*, SDL_putenv as a no-op). The prefix
  also fixes PATH_MAX at 1024: the toolchain's limits.h and
  sys/syslimits.h disagree (4096/1024), and DXX passes
  std::array<char, PATH_MAX> between files.
- similar/main/vers_id.cpp's build record (shown in demos) is filled in
  by the Makefile, as SConstruct does.
- amiga/pthread_stubs.c: libstdc++ asks for POSIX threads; the game has
  one thread (DXX uses no std::thread), so they are single-thread stubs.

Big-endian and alignment
------------------------

DXX_WORDS_BIGENDIAN is 1 (SConstruct's test, and __BYTE_ORDER__ on the
68k). PhysicsFS reads HOG headers with its own byte swapping. DXX reads
PIG/HOG data, levels (RDL), pilots and saved games field by field
through PHYSFSX_readInt/Short and friends, or reads packed structures
(__attribute__((packed)), size-checked by static_assert, so the 68k's
2-byte alignment of int cannot change their layout) and swaps them.
Two readers did not swap, and are fixed:

- common/misc/hmp.cpp: the HMP track count and each track's length
  were used as read; on a big-endian machine the length became a huge
  or negative allocation and read size. Both are now INTEL_INT()'d and a
  negative length is refused. (No music plays here, but the reader is
  built.)
- d1x-rebirth/main/custom.cpp: custom-texture PIG/POG headers (offsets,
  sound lengths) were used unswapped, giving wrong seeks and sizes for
  custom missions' replacement textures and sounds.

Licence
-------

DXX-Rebirth: GPL 3 with an additional permission (COPYING.txt): the
original Descent code is under the Parallax licence, which allows use,
display and derivative works for non-commercial, royalty- and
revenue-free purposes only; the Rebirth contributors' code is GPL 3, and
GPL terms that conflict with the Parallax licence are excused only as far
as needed. So this port may be shared freely and with its source, but
never sold or used for revenue. PhysicsFS is zlib-licensed. All are in
COPYING.
