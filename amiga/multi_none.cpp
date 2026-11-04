/*
 * The multiplayer dispatch table of a build with no network protocol
 * (DXX_USE_MULTIPLAYER without DXX_USE_UDP; see common/main/net_udp.h).
 * No network game can be started or joined, so nothing here is called in
 * play; each entry does nothing and reports nothing done.
 * The AmiCradle Team. GPL 3, like DXX-Rebirth.
 */
#include "dxxsconf.h"
#include "net_udp.h"

#if DXX_USE_MULTIPLAYER && !DXX_USE_UDP

namespace dsx {
namespace multi {
namespace none {

const dispatch_table dispatch{};

void dispatch_table::send_data(std::span<const uint8_t>, multiplayer_data_priority) const
{
}

void dispatch_table::send_data_direct(std::span<const uint8_t>, playernum_t, int) const
{
}

int dispatch_table::objnum_is_past(objnum_t) const
{
	return 0;
}

void dispatch_table::do_protocol_frame(int, int) const
{
}

window_event_result dispatch_table::level_sync() const
{
	return window_event_result::handled;
}

void dispatch_table::send_endlevel_packet() const
{
}

void dispatch_table::kick_player(const _sockaddr &, kick_player_reason) const
{
}

void dispatch_table::disconnect_player(int) const
{
}

int dispatch_table::end_current_level(
#if DXX_BUILD_DESCENT == 1
	next_level_request_secret_flag *
#endif
	) const
{
	return 0;
}

void dispatch_table::leave_game() const
{
}

}
}
}

#endif
