function vc_version()
  local VER = lake.compiler_version()
  MSVC_VER = ({
    [15] = '9';
    [16] = '10';
  })[VER.MAJOR] or ''
  return MSVC_VER
end

local function arkey(t)
  assert(type(t) == 'table')
  local keys = {}
  for k in pairs(t) do
    assert(type(k) == 'number')
    table.insert(keys, k)
  end
  table.sort(keys)
  return keys
end

local function ikeys(t)
  local keys = arkey(t)
  local i = 0
  return function()
    i = i + 1
    local k = keys[i]
    if k == nil then return end
    return k, t[k]
  end
end

local function expand(arr, t)
  if t == nil then return arr end

  if type(t) ~= 'table' then
    table.insert(arr, t)
    return arr
  end

  for _, v in ikeys(t) do
    expand(arr, v)
  end

  return arr
end

function L(...)
  return expand({}, {...})
end

J = J or path.join

IF = IF or lake.choose or choose

function prequire(...)
  local ok, mod = pcall(require, ...)
  if ok then return mod end
end

function each_join(dir, list)
  for i, v in ipairs(list) do
    list[i] = path.join(dir, v)
  end
  return list
end

function run(file, cwd)
  print()
  print("run " .. file)
  if not TESTING then
    if cwd then lake.chdir(cwd) end
    local status, code = utils.execute( LUA_RUNNER .. ' ' .. file )
    if cwd then lake.chdir("<") end
    print()
    return status, code
  end
  return true, 0
end

function run_test(name, params)
  local test_dir = J(ROOT, 'test')
  local cmd = J(test_dir, name)
  if params then cmd = cmd .. ' ' .. params end
  local ok = run(cmd, test_dir)
  print("TEST " .. cmd .. (ok and ' - pass!' or ' - fail!'))
end

function spawn(file, cwd)
  local winapi = prequire "winapi"
  if not winapi then
    print(file, ' error: Test needs winapi!')
    return false
  end
  print("spawn " .. file)
  if not TESTING then
    if cwd then lake.chdir(cwd) end
    assert(winapi.shell_exec(nil, LUA_RUNNER, file, cwd))
    if cwd then lake.chdir("<") end
    print()
  end
  return true
end

function as_bool(v,d)
  if v == nil then return not not d end
  local n = tonumber(v)
  if n == 0 then return false end
  if n then return true end
  return false
end

-----------------------
-- needs --
-----------------------

lake.define_need('lua53', function()
  return {
    incdir = J(ENV.LUA_DIR_5_3, 'include');
    libdir = J(ENV.LUA_DIR_5_3, 'lib');
    libs = {'lua53'};
  }
end)

lake.define_need('lua52', function()
  return {
    incdir = J(ENV.LUA_DIR_5_2, 'include');
    libdir = J(ENV.LUA_DIR_5_2, 'lib');
    libs = {'lua52'};
  }
end)

lake.define_need('lua51', function()
  return {
    incdir = J(ENV.LUA_DIR, 'include');
    libdir = J(ENV.LUA_DIR, 'lib');
    libs = {'lua5.1'};
  }
end)

local ZLIB_DIR = ZLIB_DIR or ENV.ZLIB_DIR or J(ENV.CPPLIB_DIR, "zlib", "1.2.7")

lake.define_need('zlib-static-md', function()
  local lib
  if MSVC then lib = "zlib_vc" .. vc_version() .. "_md"
  else lib = "z" end

  return {
    incdir = J(ZLIB_DIR, 'include');
    libdir = J(ZLIB_DIR, 'static');
    libs = {lib};
  }
end)

lake.define_need('zlib-static-mt', function()
  local lib
  if MSVC then lib = "zlib_vc" .. vc_version() .. "_mt"
  else lib = "z" end

  return {
    incdir = J(ZLIB_DIR, 'include');
    libdir = J(ZLIB_DIR, 'static');
    libs = {lib};
  }
end)

