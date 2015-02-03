--
--  Test is_file()
--

local fs = require( "libluafs" );

function test_is_file( file )

   local stat, err_msg = fs.stat( file )
   if stat == nil then
        return 'statError', 'get stat err:' .. err_msg
   end

   local rst, err_msg = fs.is_file( file )
   if rst == nil then
        return 'isfileError', 'is_file err:' .. err_msg
   end

   if not rst or stat.type ~= 'file' then
       return 'typeError', file .. ' is not general file'
   end

    return nil, nil
end

function run_test_is_file()
    print(' run test is_file...')

    for _, case in pairs({
                {'test_dir','/tmp', 'typeError'},
                {'test_file','11-is_file.lua', nil },
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_is_file( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test is_file, ok')
end

run_test_is_file()

