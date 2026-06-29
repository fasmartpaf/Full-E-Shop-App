# This file is included in the Linux build of Flutter. It should not be modified.

cmake_minimum_required(VERSION 3.10)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated_plugins")

# Flutter-engine related variables
set(FLUTTER_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE STRING "")
set(FLUTTER_EPHEMERAL_DIR "${FLUTTER_ROOT_DIR}/.dart_tool/flutter_build" CACHE STRING "")

# Generated plugin CMakeLists file (created by flutter pub get).
include("${FLUTTER_MANAGED_DIR}/generated_plugins.cmake")
