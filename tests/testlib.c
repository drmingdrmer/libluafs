
/**  testlib.c
 */

#ifdef __hp3000s900
/* both HP C and gcc on MPE have __hp3000s900 predefined */
#define _POSIX_SOURCE 1
#endif

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define   __USE_BSD 1
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <utime.h>
#include <pwd.h>
#include <grp.h>

#define MYNAME  "testlib"

#include "lua.h"
#include "lauxlib.h"

#ifndef RELEASE
#  define RELEASE "1.0"
#endif

/**
 * Find and return the version identifier from our CVS marker.
 * @return A static memory buffer containing the version number
 */

static char * getVersion( )
{
    static char marker[] = { "libluafs.c v" RELEASE };
    return( marker );
}

/**
  * Return an error string to the LUA script.
  * @param L The Lua intepretter object.
 * @param info An error string to return to the caller.
*/

static int _return(lua_State *L, const char *info)
{
    lua_pushnil(L);

    if (info==NULL)
        lua_pushstring(L, "unknown error");
    else
        lua_pushstring(L, info);

    return 2;
}

/**
 * Return an error string to the LUA script.
 * @param L The Lua intepretter object.
 * @param info An error string to return to the caller.  Pass NULL to use the return value of strerror.
 */

static int pusherror(lua_State *L, const char *info)
{
    int save_errno = errno;      /* in case lua_pushnil() or lua_pushfstring changes errno */

    lua_pushnil(L);

    if (info==NULL)
        lua_pushstring(L, strerror(save_errno));
    else
        lua_pushfstring(L, "%s: %s", info, strerror(save_errno));

    lua_pushnumber(L, save_errno);

    return 3;
}

/***
 ***  Now we have the actual functions which are exported to Lua
 ***/

/**
 * get user id by username.
 * @param L The lua intepreter object.
 * @return The number of results to be passed back to the calling Lua script.
 */
static int pGetuid(lua_State *L)
{
    const char *uname;
    struct passwd *p;

    if (! lua_isstring(L, 1))
        return( _return(L, "getuid(string);" ) );

    uname = lua_tostring(L, 1);

    if ( (p = getpwnam(uname)) == NULL )
        return(pusherror(L, "Failed to getuid()" ) );

    /* Success */
    lua_pushnumber(L, (lua_Number)(p->pw_uid));

    return 1;
}

/**
 * get group id by group name.
 * @param L The lua intepreter object.
 * @return The number of results to be passed back to the calling Lua script.
 */
static int pGetgid(lua_State *L)
{
    const char *gname;
    struct group *p;

    if (! lua_isstring(L, 1))
        return( _return(L, "getgid(string);" ) );

    gname = lua_tostring(L, 1);

    if ( (p = getgrnam(gname)) == NULL )
        return(pusherror(L, "Failed to getgid()" ) );

    /* Success */
    lua_pushnumber(L, (lua_Number)(p->gr_gid));

    return 1;
}
/**
 * Mappings between the LUA code and our C code.
 */
/**
 * Mappings between the LUA code and our C code.
 */

static const luaL_reg R[] =
{
    {"getuid",           pGetuid},
    {"getgid",           pGetgid},
    {NULL,              NULL}
};

/**
 * Bind our exported functions to the Lua intepretter, making our functions
 * available to the calling script.
 * @param L The lua intepreter object.
 * @return 1 (for the table we leave on the stack)
 */

LUALIB_API int luaopen_testlib(lua_State *L)
{
    /* Version number from CVS marker. */
    char *version = getVersion();

#ifdef PRE_LUA51
    luaL_openlib(L, MYNAME, R, 0);
#else
    luaL_register(L, MYNAME, R);
#endif

    lua_pushliteral(L, "version");
    lua_pushstring(L, version );
    lua_settable(L, -3);

    return 1;
}

