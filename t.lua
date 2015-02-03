#!/usr/local/bin/lua

fs = require( "libluafs" )
--fs = assert(package.loadlib("./libluafs.so","luaopen_libluafs"))()
--print( fs.mtime("./README",7,-7) )
print( fs.makedir("./README2",1111) )
