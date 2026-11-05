D1X-Rebirth for AmigaOS 3.x
===========================

This is DXX-Rebirth's Descent 1 engine (D1X-Rebirth) for AmigaOS 3.x on a
68040 or 68060 with FPU, drawn with DXX's own software renderer on an
8-bit screen (AGA or RTG) through acsdl12, the AmiCradle Team's SDL 1.2.
Descent 2 is not part of this port.

Upstream: https://github.com/dxx-rebirth/dxx-rebirth, revision
6943b924bea749543ef5729f31a28345e79716d2 (master of 2026-10-11).

Running it
----------

1. Put descent.hog and descent.pig from Descent 1 (the freely
   distributable shareware 1.4, or the full game 1.4/1.5) into the Data
   drawer. See Data/ReadMe. No game data comes with this port.
2. Double-click Descent. The icon asks for a 512 KB stack; from a Shell,
   "Stack 524288" first.

Settings (descent.cfg), pilots, saved games, demos and screenshots are
written to the Descent drawer (PROGDIR:). The screen opens at 320x200;
other sizes can be picked in Options > Graphics, at a cost in speed.
d1x.ini in the Descent drawer takes command-line options, as upstream.

What this build leaves out
--------------------------

- Music. Descent's music is HMP (MIDI); acsdl12 plays no MIDI, and its
  SDL_mixer subset is not used (sdlmixer=0), so there is no music and no
  external OGG/MP3 music. CD audio is out too (acsdl12 has no SDL_CD).
  Sound effects play: they come from descent.pig through DXX's own mixer
  (digi_audio.cpp) on SDL_OpenAudio.
- Network games. There is no UDP stack in this build, so Multiplayer has
  nothing to start or join; the multiplayer code is built with an empty
  protocol (amiga/multi_none.cpp).
- OpenGL, the level editor, PNG screenshots (screenshots are PCX).
- Keys the Amiga does not have (Home, End, Page Up/Down, Insert, Pause,
  F11, F12) cannot be bound.

Building
--------

    make -f amiga/Makefile.amigaos -j2

The defaults find GFOpenAmigaGCC 16.2.0-open4 (STOVE), the NDK, acsdl12
and ACGame under $HOME/CradleLab; override STOVE=, NDK=, ACSDL=, ACGAME=
as needed. The output is build/amigaos/Descent/ with Descent.info beside
it. Each C++ file needs several hundred MB to compile; on a small machine
use -j1 or -j2.

Upstream builds with SCons. amiga/Makefile.amigaos builds the sources
SConstruct picks for

    scons d1x=1 d2x=0 opengl=0 sdl2=0 sdlmixer=0 sdlimage=0 use_udp=0
          editor=0 host_endian=big screenshot=legacy

with SConstruct's own warning flags, and amiga/dxxsconf.h is the header
SConstruct's tests wrote when run with this compiler (see its comment for
what differs). The kconfig table is made with upstream's
generate-kconfig-udlr.py, as SCons does.

PhysicsFS
---------

PhysicsFS 3.2.0 (release-3.2.0, eb3383b532c5f74bfeb42ec306ba2cf80eed988c,
zlib licence, amiga/physfs/LICENSE.txt) is built into the program: the
directory, HOG and ZIP archivers only. amiga/physfs/physfs_platform_amiga.c
is a dos.library platform layer: AmigaDOS names, in which a trailing "/"
means the parent drawer, are tidied before they are opened; the base,
user and pref dirs are all PROGDIR:. Small marked changes in physfs.h,
physfs_internal.h and physfs_platforms.h select it and drop the GCC
visibility and __sync atomics the Amiga toolchain lacks. Its zip reader
has its own inflate; zlib is not needed.

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
