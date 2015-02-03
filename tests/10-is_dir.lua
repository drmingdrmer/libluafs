--
--  Test is_dir()
--

local fs = require( "libluafs" );

function test_is_dir( file )

   local stat, err_msg = fs.stat( file )
   if stat == nil then
        return 'statError', 'get stat err:' .. err_msg
   end

   local rst, err_msg = fs.is_dir( file )
   if rst == nil then
        return 'isdirError', 'is_dir err:' .. err_msg
   end

   if not rst or stat.type ~= 'directory' then
      return 'typeError', file .. 'is not directory'
   end

    return nil, nil
end

function run_test_is_dir()
    print(' run test is_dir...')

    for _, case in pairs({
                {'test_dir','.', nil},
                {'test_dir','..', nil},
                {'test_dir','/tmp', nil},
                {'test_non_dir','10-is_dir.lua', 'typeError' },
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] )

        local err_code, err_msg = test_is_dir( case[2] )
        if err_code ~= case[3] then
            print('test false, except:' .. tostring(case[3])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test is_dir, ok')
end

run_test_is_dir()
