/*
 * Included ahead of every DXX-Rebirth source on AmigaOS (-include).
 *
 * libstdc++ pulls in the toolchain's pthread.h, which wraps close(),
 * read(), open() and the other cancellation points in function-like
 * macros, and those macros also catch members of the same names
 * (SDL_RWops's ctx->close(ctx), for one). The game has one thread and
 * nothing to cancel, so pthread.h is read here once, after the headers it
 * looks for, and its wrappers are taken away again.
 *
 * Then the few SDL 1.2 names DXX uses that acsdl12 leaves out
 * (amiga/sdl12_extra.h), and nanosleep(), which libnix has but does not
 * declare, INET_ADDRSTRLEN, and one PATH_MAX.
 * The AmiCradle Team. GPL 3, like DXX-Rebirth.
 */
#ifndef AMIGA_PREFIX_H
#define AMIGA_PREFIX_H

#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>

#undef close
#undef fsync
#undef read
#undef sleep
#undef usleep
#undef creat
#undef fcntl
#undef open
#undef nanosleep
#undef system

#ifdef __cplusplus
extern "C" {
#endif
int nanosleep(const struct timespec *req, struct timespec *rem);
#ifdef __cplusplus
}
#endif

/* The toolchain's limits.h says PATH_MAX is 4096 and sys/syslimits.h
 * says 1024, so it depended on which a source read first, and DXX sizes
 * std::array<char, PATH_MAX> parameters with it: one value everywhere. */
#include <limits.h>
#include <sys/syslimits.h>
#undef PATH_MAX
#define PATH_MAX 1024

/* libnix's netinet/in.h has sockaddr_in but not INET_ADDRSTRLEN, which
 * multi.h sizes an (unused) address buffer with. */
#ifndef INET_ADDRSTRLEN
#define INET_ADDRSTRLEN 16
#endif

#include "sdl12_extra.h"

#endif
