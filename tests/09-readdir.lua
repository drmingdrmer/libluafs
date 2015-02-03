--
--  Test readdir()
--

fs = require( "libluafs" );

function test_readdir( name )
    local rst, err_msg = fs.readdir( name )
    if rst == nil then
        return nil, 'readdirError', err_msg
    end

    return rst, nil, nil
end


function _mkdirs( names )
    for i, n in ipairs( names ) do
        fs.mkdir( n )
    end
end

function _rmdirs( names )
    for i=#names, 1, -1 do
        fs.rmdir( names[i] )
    end
end

function run_test_readdir()
    print(' run test readdir...')

    local dirs = {'./tmp','./tmp/t1','./tmp/t2'}
    _mkdirs( dirs )

    for _, case in pairs({
                {'test_tmp_dir','./tmp', {'.','..','t1','t2'}, nil},
                {'test_empty_dir','./tmp/t1', {'.','..'}, nil},
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local rst, err_code, err_msg = test_readdir( case[2] )
        if err_code ~= case[4] then
            print('test false, except:' .. tostring(case[4])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            _rmdirs( dirs )
            os.exit(1)
        end

        table.sort(case[3])
        table.sort(rst)
        for i, n in ipairs( case[3] ) do
            if rst[i] ~= n then
                print( 'test false except read file:'.. n
                    .. 'act:' .. rst[i] )
                _rmdirs( dirs )
                os.exit(1)
            end
        end
    end

    _rmdirs( dirs )
    print(' run test readdir... ok')
end

run_test_readdir()
