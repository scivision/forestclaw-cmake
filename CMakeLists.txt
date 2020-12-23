cmake_minimum_required(VERSION 3.13)

include(cmake/compiler_find.cmake)
find_c_fortran()

project(forestclaw
  LANGUAGES C
  DESCRIPTION "Build and use forestclaw (autotools-based) from CMake projects"
  HOMEPAGE_URL https://github.com/ForestClaw/forestclaw)

include(CTest)

set(FORESTCLAW_ROOT ${PROJECT_BINARY_DIR})
set(forestclaw_src ${FORESTCLAW_ROOT}/src/forestclaw)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
message(STATUS "CMake ${CMAKE_VERSION} using ${Ncpu} threads")

# --- help autotools based on CMake variables

find_package(MPI COMPONENTS C)

set(forestclaw_flags --prefix=${FORESTCLAW_ROOT})
set(forestclaw_mpi)
if(MPI_C_FOUND)
  set(forestclaw_mpi --enable-mpi)
endif()

include(ExternalProject)

ExternalProject_Add(forestclaw
GIT_REPOSITORY https://github.com/ForestClaw/forestclaw.git
GIT_TAG master
GIT_SHALLOW true
UPDATE_DISCONNECTED true
PREFIX ${FORESTCLAW_ROOT}
CONFIGURE_COMMAND ${forestclaw_src}/configure ${forestclaw_flags} ${forestclaw_mpi}
BUILD_COMMAND make -j${Ncpu}
INSTALL_COMMAND make -j${Ncpu} install
TEST_COMMAND ""
)

ExternalProject_Get_Property(forestclaw SOURCE_DIR)

ExternalProject_Add_Step(forestclaw
  bootstrap
  COMMAND ./bootstrap
  DEPENDEES download
  DEPENDERS configure
  WORKING_DIRECTORY ${SOURCE_DIR})
