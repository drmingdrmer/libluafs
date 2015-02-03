--
--  Test chmod().
--

fs = require( "libluafs" )

function test_chmod( name, mode )

   local stat, err_msg = fs.stat( name )
   if stat == nil then
        return 'statError', err_msg
   end;

   local original = stat.mode

   local rst, err_msg = fs.chmod( name, mode )
   if rst == nil then
        fs.chmod( name, original )
        return 'chmodError', err_msg
    end

   local n_stat, err_msg = fs.stat( name )
   if  n_stat == nil then
        fs.chmod( name, original )
        return 'statError', err_msg
   end;

   if n_stat.mode ~= mode then
        fs.chmod( name, original )
        return 'modeError', 'mode not match'
   end

   fs.chmod( name, original )
end

function run_test_chmod()
    print(' run test chmod...')

    for _, case in pairs({
                { "test_chmod_755", "07-chmod.lua", 755, nil },
                { "test_chmod_600", "07-chmod.lua", 600, nil },
                { "test_chmod_555", "07-chmod.lua", 555, nil },
                { "test_chmod_777", "07-chmod.lua", 777, nil },
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] .. ',' .. case[3] )

        local err_code, err_msg = test_chmod( case[2], case[3] )
        if err_code ~= case[4] then
            print('test false, except:' .. tostring(case[4])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test chmod... ok')
end

run_test_chmod()
