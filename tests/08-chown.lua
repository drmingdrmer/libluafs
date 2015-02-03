--
--  Test chown().
--

local testlib = require( "testlib" );
local fs = require( "libluafs" );

function test_chown( file, owner, group )

   local ori_stat, err_msg = fs.stat( file )
   if ori_stat == nil then
        return 'statError', 'get stat err:' .. err_msg
   end

   local rst, err_msg = fs.chown( file, owner, group )
   if rst == nil then
        return 'chownError', 'chown err:' .. err_msg
   end

   local n_stat, err_msg = fs.stat( file )
   if n_stat == nil then
        return 'statError', 'get new stat err:' .. err_msg
   end

   local uid = owner
   if tonumber( uid ) == nil then
       uid = testlib.getuid( uid )
    end
   if n_stat.uid ~= uid then
       return 'userError', 'change owner error'
    end

   local gid = group
   if tonumber( gid ) == nil then
       gid = testlib.getgid( gid )
    end
   if n_stat.gid ~= gid then
       return 'groupError', 'change group error'
    end

   rst, err_msg = fs.chown( file, ori_stat.uid , ori_stat.gid )
   if rst == nil then
        return 'chownError', 'restore chown err:' .. err_msg
   end
end

function run_test_chown()
    print(' run test chown...')

    for _, case in pairs({
                {'test_uname_gname','shuwen5','shuwen5', nil},
                {'test_uname_gname','shuwen5','root', nil},
                {'test_uname_num_gname','shuwen5', 0, nil},
                {'test_num_uname_num_gname',567, 0, nil},
                {'test_fix_uname_gname','shuwen6','shuwen5','chownError'},
                {'test_uname_fix_gname','shuwen5','shuwen6','chownError'},
                {'test_fix_uname_fix_gname','shuwen6','shuwen6','chownError'},
                {'test_root_gname','root','shuwen5',nil},
                }) do

        print('    ' .. case[1] .. ', args:' .. case[2] .. ',' .. case[3])

        local err_code, err_msg = test_chown( 'test_file.txt', case[2], case[3] )
        if err_code ~= case[4] then
            print('test false, except:' .. tostring(case[4])
                ..', act:' .. tostring(err_code)
                .. ', msg:' .. tostring(err_msg) )

            os.exit(1)
        end
    end

    print(' run test chown... ok')
end

run_test_chown()
