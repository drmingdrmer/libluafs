--
--  Test chdir().
--

fs = require( "libluafs" );

function test_chdir( path )
    local ori_dir, err_msg = fs.cwd()
    if ori_dir == nil then
        return 'cwdError', err_msg
    end

    local rst, err_msg = fs.chdir( path )
    if rst == nil then
        return 'chdirError', err_msg
    end

    local n_dir, err_msg = fs.cwd()
    if n_dir == nil then
        return 'cwdError', err_msg
    end

    if path == '.' then
        if ori_dir ~= n_dir then
            return 'chdirError', 'change dir error'
        end
    elseif path == '..' then
        if string.match( ori_dir, '(/.*)/') ~= n_dir then
            return 'chdirError', 'change dir error'
        end
    elseif path ~= n_dir then
        return 'chdirError', 'change dir error'
    else
        -- equal, do nothing
    end

    rst, err_msg = fs.chdir( ori_dir )
    if rst == nil then
        return 'chdirError', err_msg
    end

    return nil, nil
end

function run_test_chdir()
    print( 'run_test_chdir...')

    for _, case in pairs({
        {'test_cur_dir','.', nil},
        {'test_parent_dir','..', nil},
        {'test_root_dir','/', nil},
        {'test_error_dir','/fjsdlf', 'chdirError'},
        }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_chdir( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print( 'run_test_chdir, ok')
end

run_test_chdir()
