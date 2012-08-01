# Copyright (C) 2007-2012 LuaDist.
# Created by Peter Drahoš
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( lzlib C )
cmake_minimum_required ( VERSION 2.8 )
include ( cmake/dist.cmake )
include ( lua )

find_library ( Z_LIBRARY NAMES zlib z )
# Find zlib

install_lua_module ( zlib lzlib.c zlib.def LINK ${Z_LIBRARY} )
install_lua_module ( gzip gzip.lua )

add_lua_test ( test_gzip.lua )
add_lua_test ( test_zlib2.lua )
add_lua_test ( test_zlib3.lua )

install_data ( README README.lgzip )
install_test ( test_zlib2.lua test_gzip.lua )
