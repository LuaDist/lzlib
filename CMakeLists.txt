# Copyright (C) 2007-2009 LuaDist.
# Created by Peter Drahoš
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

PROJECT(lzlib C)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
INCLUDE(dist.cmake)

FIND_LIBRARY ( Z_LIBRARY NAMES z)  # Find zlib

ADD_LUA_MODULE(zlib lzlib.c zlib.def)
TARGET_LINK_LIBRARIES(zlib ${Z_LIBRARY})

ADD_LUA_TEST(test_gzip.lua)
ADD_LUA_TEST(test_zlib2.lua)
ADD_LUA_TEST(test_zlib3.lua)

INSTALL (TARGETS zlib DESTINATION ${INSTALL_CMOD})
INSTALL (FILES gzip.lua DESTINATION ${INSTALL_LMOD})
INSTALL (FILES README README.lgzip DESTINATION ${INSTALL_DATA})
INSTALL (FILES test_zlib2.lua test_gzip.lua DESTINATION ${INSTALL_TEST})
