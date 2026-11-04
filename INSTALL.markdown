# Installing D1X-Rebirth and D2X-Rebirth

## Install the game data

DXX-Rebirth requires game data to play.  This repository does not provide game data.

You can download [Descent 1 PC shareware data](https://icculus.org/d2x/data/desc14sw.tar.gz), [Descent 1 Mac shareware data](https://icculus.org/d2x/data/descent.tar.gz), [Descent 2 PC demo data](https://icculus.org/d2x/data/d2shar10.tar.gz), or [Descent 2 Mac demo data](https://icculus.org/d2x/data/descent2preview.tar.gz) for free from [icculus.org/d2x/](https://icculus.org/d2x/).  You only need PC data or Mac data, but not both, to play a game.  Links to both are provided because some people prefer some of the supporting assets from the Mac data.  You can use PC or Mac data without regard to what operating system you will use to play Rebirth.  Full game data is supported and recommended, but not freely distributable.  You can [buy full Descent 1 game data](https://www.gog.com/game/descent) and/or [buy full Descent 2 game data](https://www.gog.com/game/descent_2) from GOG.com.  DXX-Rebirth contains engines for both games.  Each engine works for its respective game without the data from the other, so players who wish to purchase only one game may do so.

If you buy the retail data from GOG, the easiest way to get the required data files is to install the game provided by GOG, then copy the data files from the GOG install directory to the Rebirth game directory described below.  If you do not want to install the game, the required files can be extracted from the installer data using [innoextract](https://constexpr.org/innoextract/).  That path is not documented here.  For Windows users, using the GOG game installer is much easier.  Once you have copied the data files to the Rebirth directory, you can uninstall the GOG game.  You will not run it.

Once you have the game data files, whether the free shareware data or the paid retail data, you must place them in a directory where Rebirth will find them.  Rebirth defaults to checking a platform-specific directory.  If your platform is:

- Windows or Mac OS X: Place the data files in the same directory as the game's executable.
- Linux, BSD: Place the data files in the sharepath directory set at build time.  The default is `${prefix}/share/games/${program}`, which would typically expand to `/usr/share/games/d1x` (for D1X-Rebirth) or `/usr/share/games/d2x` (for D2X-Rebirth).

For all platforms, if you pass the command line option `-hogdir DIRECTORY`, the game will search the directory named `DIRECTORY` in addition to searching the platform-specific directory.

The files you must provide are:
- For D1X-Rebirth:
  - `descent.hog`
  - `descent.pig`
- For D2X-Rebirth Mac shareware:
  - `d2demo.ham`
  - `d2demo.hog`
  - `d2demo.pig`
  - `descent2.s11`
  - `exit.ham`
- For D2X-Rebirth PC shareware:
  - `d2demo.ham`
  - `d2demo.hog`
  - `d2demo.pig`
- For D2X-Rebirth retail data:
  - `alien1.pig`
  - `alien2.pig`
  - `descent2.ham`
  - `descent2.hog`
  - `descent2.s22`
  - `fire.pig`
  - `groupa.pig`
  - `ice.pig`
  - `water.pig`

For D2X-Rebirth retail data, if you want the lower bitrate sound effects, then you need `descent2.s11`.  The lower bitrate effects might be needed on very constrained systems, but most people will want `descent2.s22` instead.  If both are present, the game will default to `descent2.s22`.  If you want to play the in-game movies, then you need the movie files: `intro-h.mvl`, `other-h.mvl`, `robots-h.mvl` or their low-resolution counterparts: `intro-l.mvl`, `other-l.mvl`, `robots-l.mvl`.  The game will play correctly without movie files.  If you intend to watch the single player mission briefings, then `robots-h.mvl` is recommended.


## Install the game engine

If you want to play without compiling, then download the latest artifact from the most recent [GitHub Actions workflow run](https://github.com/dxx-rebirth/dxx-rebirth/actions).  Pick the artifact corresponding to your platform.  If your platform is:

- Windows: download `DXX-Rebirth-Windows-x86_64`
- Mac OS X: download `DXX-Rebirth-MacOS14-arm64`
- Linux x86\_64: download `DXX-Rebirth-Linux-AppImage-x86_64`

If you prefer to build from source or none of these are suitable for your platform, then see the [build instructions](Documentation/building.md).
