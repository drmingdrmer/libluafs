--
-- Test mkdir().
--
fs = require( "libluafs" );

--
--  Test that a new directory is created
--

function test_mkdir( path )
    local stat = fs.stat( path );

    local rst, err_msg, err_no = fs.mkdir( path );
    if rst == nil then
        fs.rmdir( path );
        if stat ~= nil and err_no == 17 then
            return 'fileExist', err_msg
        end
        return 'mkdirError', err_msg
    end

    stat, err_msg, err_no = fs.stat( path );
    if stat == nil or stat.type ~= 'directory' then
        fs.rmdir( path );
        return 'statError', err_msg
    end

    fs.rmdir( path )

    return nil, nil
end

function run_test_mkdir()

    print( 'run_test_mkdir...')

    for _, case in pairs({
            {'test_null_dir','', 'mkdirError'},
            {'test_tmp_dir','./tmp_dir', nil},
            {'test_tmp_dir_tmp','./tmp_dir/tmp','mkdirError'},
            {'test_exist_dir','./tmp_exist_dir','fileExist'},
            }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        if case[1] == 'test_exist_dir' then
            local rst, err_msg = fs.mkdir( case[2])
            if rst == nil then
                print('test false, err:'.. err_msg)
                os.exit(1)
            end
        end

        local err_code, err_msg = test_mkdir( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print( 'run_test_mkdir, ok')
end

run_test_mkdir()
