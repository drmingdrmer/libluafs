
--
--  Test id_exist()
--

local fs = require( "libluafs" );

function test_is_exist( file )

   local stat, err_msg = fs.stat( file )

   local rst, err_msg = fs.is_exist( file )
   if rst == nil then
        return 'isexistError', 'is_exist err:' .. err_msg
   end

   if not rst or stat == nil then
       return 'doesnotExist', file .. '  does not exist'
   end

    return nil, nil
end

function run_test_is_exist()
    print(' run test is_exist...')

    for _, case in pairs({
                {'test_cur_dir','.', nil},
                {'test_parent_dir','..', nil},
                {'test_file','12-is_exist.lua', nil },
                {'test_file','baba.test', 'doesnotExist' },
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_is_exist( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test is_exist, ok')
end

run_test_is_exist()

