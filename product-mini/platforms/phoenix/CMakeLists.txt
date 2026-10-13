# Copyright (C) 2026 Phoenix Systems.  All rights reserved.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

cmake_minimum_required(VERSION 3.14)

include(CheckPIESupported)

project(iwasm)

set(CMAKE_VERBOSE_MAKEFILE OFF)

set(WAMR_BUILD_PLATFORM "phoenix")

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

if(NOT DEFINED WAMR_BUILD_TARGET)
  message(SEND_ERROR "Unspecified build target platform")
endif()

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

if(NOT DEFINED WAMR_BUILD_INTERP)
  set(WAMR_BUILD_INTERP 1)
endif()

if(NOT DEFINED WAMR_BUILD_AOT)
  set(WAMR_BUILD_AOT 0)
endif()

if(NOT DEFINED WAMR_BUILD_JIT)
  set(WAMR_BUILD_JIT 0)
endif()

if(NOT DEFINED WAMR_BUILD_FAST_JIT)
  set(WAMR_BUILD_FAST_JIT 0)
endif()

if(NOT DEFINED WAMR_BUILD_LIBC_BUILTIN)
  set(WAMR_BUILD_LIBC_BUILTIN 1)
endif()

if(NOT DEFINED WAMR_BUILD_LIBC_WASI)
  set(WAMR_BUILD_LIBC_WASI 1)
endif()

if(NOT DEFINED WAMR_BUILD_FAST_INTERP)
  set(WAMR_BUILD_FAST_INTERP 1)
endif()

if(NOT DEFINED WAMR_BUILD_MULTI_MODULE)
  set(WAMR_BUILD_MULTI_MODULE 1)
endif()

if(NOT DEFINED WAMR_BUILD_LIB_PTHREAD)
  set(WAMR_BUILD_LIB_PTHREAD 0)
endif()

if(NOT DEFINED WAMR_BUILD_LIB_WASI_THREADS)
  set(WAMR_BUILD_LIB_WASI_THREADS 1)
endif()

if(NOT DEFINED WAMR_BUILD_MINI_LOADER)
  set(WAMR_BUILD_MINI_LOADER 0)
endif()

if(NOT DEFINED WAMR_BUILD_SIMD)
  set(WAMR_BUILD_SIMD 1)
endif()

if(NOT DEFINED WAMR_BUILD_REF_TYPES)
  set(WAMR_BUILD_REF_TYPES 1)
endif()

if(NOT DEFINED WAMR_BUILD_DEBUG_INTERP)
  set(WAMR_BUILD_DEBUG_INTERP 0)
endif()

if(WAMR_BUILD_DEBUG_INTERP EQUAL 1)
  set(WAMR_BUILD_FAST_INTERP 0)
  set(WAMR_BUILD_MINI_LOADER 0)
  set(WAMR_BUILD_SIMD 0)
endif()

if(WAMR_BUILD_WASI_NN EQUAL 1)
  # Show error, cannot build shared libraries
endif()

set(WAMR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../..)

include(${WAMR_ROOT_DIR}/build-scripts/runtime_lib.cmake)

check_pie_supported()

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections")

# Optimize build for size
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os")

include(${SHARED_DIR}/utils/uncommon/shared_uncommon.cmake)

add_executable(iwasm main.c ${UNCOMMON_SHARED_SOURCE})

set_version_info(iwasm)
set_target_properties(iwasm PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_link_libraries(iwasm vmlib)
install(TARGETS iwasm DESTINATION bin)
add_library(vmlib ${WAMR_RUNTIME_LIB_SOURCE})
set_version_info(vmlib)
target_include_directories(vmlib INTERFACE $<INSTALL_INTERFACE:include>)
set(WAMR_PUBLIC_HEADERS
  ${WAMR_ROOT_DIR}/core/iwasm/include/wasm_c_api.h
  ${WAMR_ROOT_DIR}/core/iwasm/include/wasm_export.h
  ${WAMR_ROOT_DIR}/core/iwasm/include/lib_export.h
)

set_target_properties(vmlib PROPERTIES
  OUTPUT_NAME iwasm
  PUBLIC_HEADER "${WAMR_PUBLIC_HEADERS}"
  POSITION_INDEPENDENT_CODE ON
)

target_link_libraries(vmlib ${LLVM_AVAILABLE_LIBS} ${UV_A_LIBS} -lm -lpthread)

install(TARGETS vmlib
  EXPORT iwasmTargets
  DESTINATION lib
  PUBLIC_HEADER DESTINATION include
)

install_iwasm_package()
