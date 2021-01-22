cmake_minimum_required(VERSION 3.15)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()

project(FORESTCLAW
  LANGUAGES C
  DESCRIPTION "Build and use Forestclaw (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/ForestClaw/forestclaw)

include(CTest)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(VERBOSE "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

# --- prereqs

if(NOT TARGET MPI::MPI_C)
  find_package(MPI COMPONENTS C)
endif()

include(cmake/forestclaw.cmake)

if(BUILD_TESTING)
  add_subdirectory(applications)
endif(BUILD_TESTING)
