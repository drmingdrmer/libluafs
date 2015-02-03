--
-- Test makedir.
--
fs = require( "libluafs" );

function test_makedir( path, mode )
    local stat = fs.stat( path );

    local rst, err_msg, err_no = fs.makedir( path, mode );
    if rst == nil then
        fs.rmdir( path );
        if stat ~= nil and err_no == 17 then
            return 'fileExist', err_msg
        end
        return 'makedirError', err_msg
    end

    stat, err_msg, err_no = fs.stat( path );
    if stat == nil or stat.type ~= 'directory' then
        fs.rmdir( path );
        return 'statError', err_msg
    end

    if stat.mode ~= mode then
        fs.rmdir( path );
        return 'modeError', 'set file mode error'
    end

    fs.rmdir( path );

    return nil, nil
end

function run_test_makedir()

    print( 'run_test_makedir...')

    for _, case in pairs({
            {'test_null_dir','',0755,'makedirError'},
            {'test_tmp_dir','./tmp_dir',0755, nil},
            {'test_tmp_dir_tmp','./tmp_dir/tmp',0755,'makedirError'},
            {'test_exist_dir','./tmp_exist_dir',0755,'fileExist'},
            }) do

        print('    ' .. case[1] .. ', args:' .. case[2] .. ',' .. case[3] )

        if case[1] == 'test_exist_dir' then
            local rst, err_msg = fs.makedir( case[2], case[3])
            if rst == nil then
                print('test false, err:'.. err_msg)
                os.exit(1)
            end
        end

        local err_code, err_msg = test_makedir( case[2], case[3] )
        if err_code ~= case[4] then
            print('test false, except:' .. tostring(case[4])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print( 'run_test_makedir, ok')
end

run_test_makedir()
