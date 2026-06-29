cmake_minimum_required(VERSION 3.10)
project(testing_app_brief)

set(BINARY_NAME "testing_app_brief")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)

set(CMAKE_CXX_STANDARD 14)

# Resolve the Flutter root directory from the flutter binary.
execute_process(
  COMMAND which flutter
  RESULT_VARIABLE result
  OUTPUT_VARIABLE flutter_executable
  OUTPUT_STRIP_TRAILING_WHITESPACE)

if(result EQUAL 0)
  string(REPLACE "/bin/flutter" "" FLUTTER_ROOT "${flutter_executable}")
else()
  message(FATAL_ERROR "Flutter not found. Ensure Flutter is in PATH.")
endif()

include("${FLUTTER_ROOT}/packages/flutter_tools/cmake/flutter.cmake")

# System-level dependencies.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK gtk+-3.0 REQUIRED)

add_subdirectory("flutter")

add_executable(${BINARY_NAME}
  "main.cc"
)

target_compile_options(${BINARY_NAME} PRIVATE
  ${GTK_CFLAGS_OTHER}
)

target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${GTK_INCLUDE_DIRS}
)

target_link_libraries(${BINARY_NAME} PRIVATE
  flutter
  ${GTK_LIBRARIES}
)

add_dependencies(${BINARY_NAME} flutter_assemble)
