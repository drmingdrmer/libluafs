--
--  Test rmdir().
--

fs = require( "libluafs" )

--
--  Test that a directory can be removed.
--
function test_rmdir( name )

    local rst, err_msg = fs.rmdir( name )
    if rst == nil then
        return 'rmdirError', err_msg
    end

    local info, err_msg = fs.stat( name );
    if info ~= nil then
        return 'rmdirError', 'directory does not remove'
    end

end

function run_test_rmdir()
    print(' run test rmdir...')

    fs.mkdir( "./tmp" );
    fs.mkdir( "./tmp/foo" );
    fs.mkdir( "./tmp/foo/bar" );

    for _, case in pairs({
                {'test_rm_nonempty_dir','./tmp/foo','rmdirError'},
                { "test_rm_dir", "./tmp/foo/bar", nil },
                { "test_rm_dir", "./tmp/foo", nil },
                { "test_rm_dir", "./tmp", nil },
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_rmdir( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test rmdir... ok')
end

run_test_rmdir()
