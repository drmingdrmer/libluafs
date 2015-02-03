--
--  Test cwd().
--

fs = require( "libluafs" );

function test_cwd( path )

    local ori_cwd, err_msg = fs.cwd();
    if ori_cwd == nil then
        return 'cwdError', err_msg
    end

    fs.chdir( path )

    local n_cwd, err_msg = fs.cwd();
    if n_cwd == nil then
        return 'cwdError', err_msg
    end

    if path == '.' then
        if ori_cwd ~= n_cwd then
            return 'cwdError', 'change current work directory error'
        end
    elseif path == '..' then
        if string.match( ori_cwd, '(/.*)/') ~= n_cwd then
            return 'cwdError', 'change current work directory error'
        end
    elseif path ~= n_cwd then
        return 'cwdError', 'change current work directory error'
    else
        -- equal, do nothing
    end

    fs.chdir( ori_cwd )
end

function run_test_cwd()
    print(' run test cwd...')

    for _, case in pairs({
                {'test_cur_dir','.', nil},
                {'test_parent_dir','..', nil},
                {'test_tmp_dir','/tmp', nil},
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_cwd( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test cwd... ok')
end

run_test_cwd()
