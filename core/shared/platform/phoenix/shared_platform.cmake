# Copyright (C) 2026 Phoenix Systems.  All rights reserved.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set(PLATFORM_SHARED_DIR ${CMAKE_CURRENT_LIST_DIR})

add_definitions(-DBH_PLATFORM_PHOENIX)

include_directories(${PLATFORM_SHARED_DIR})
include_directories(${PLATFORM_SHARED_DIR}/../include)

include(${CMAKE_CURRENT_LIST_DIR}/../common/posix/platform_api_posix.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../common/math/platform_api_math.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../common/memory/platform_api_memory.cmake)

file(GLOB_RECURSE source_all ${PLATFORM_SHARED_DIR}/*.c)

set(PLATFORM_SHARED_SOURCE ${source_all} ${PLATFORM_COMMON_POSIX_SOURCE} ${PLATFORM_COMMON_MATH_SOURCE} ${PLATFORM_COMMON_MEMORY_SOURCE})

file(GLOB header ${PLATFORM_SHARED_DIR}/../include/*.h)
list(APPEND RUNTIME_LIB_HEADER_LIST ${header})
