local zlib = require 'zlib'
local chunk = ("0"):rep(1024)
local crc   = zlib.crc32()

assert(0 == crc)

crc = zlib.crc32(crc, chunk)
assert(2900260604 == crc)

crc = zlib.crc32(crc, chunk)
assert(3309519361 == crc)

crc = zlib.crc32(crc, chunk)
assert(3284388706 == crc)

crc = zlib.crc32(crc, chunk)
assert(2038734619 == crc)

print("Done!")

