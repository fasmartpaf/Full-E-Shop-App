cmake_minimum_required(VERSION 3.10)
project(testing_app_brief)

set(BINARY_NAME "testing_app_brief")
set(BINARY_NAME_LIB "lib${BINARY_NAME}")

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

set(FLUTTER_EXECUTABLE "${FLUTTER_ROOT}/bin/flutter")

add_subdirectory("flutter")

# System-level dependencies. Add any linux-only deps here.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK gtk+-3.0 REQUIRED)

add_executable(${BINARY_NAME}
  "main.cc"
)

target_compile_options(${BINARY_NAME} PRIVATE
  ${GTK_CFLAGS_OTHER}
)

target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_SOURCE_DIR}"
  ${GTK_INCLUDE_DIRS}
)

target_link_libraries(${BINARY_NAME} PRIVATE
  flutter
  ${GTK_LIBRARIES}
)

# Copy the Flutter library's binaries to the executable's directory so that it
# can find the libflutter.so file when run.
add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -P
    "${FLUTTER_MANAGED_DIR}/generated_plugins_linux.cmake"
)
