--
--  Test we can load the library at all
--

fs = require( "libluafs" );

if ( fs ~= nil ) then
    print("OK\tLoaded OK " .. fs.version);
else
    print("FAILED\tCouldn't load library" );
end
