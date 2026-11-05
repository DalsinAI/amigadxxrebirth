/* D1X-Rebirth recurses when it renders (the segment tree), when it loads
 * and when it parses its menus, and a Shell's 4 KB stack is far too
 * little; libnix's startup sets up this much instead.
 * The AmiCradle Team. GPL 3, like DXX-Rebirth. */
unsigned long __stack = 512 * 1024;
