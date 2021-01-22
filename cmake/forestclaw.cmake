include(ExternalProject)

function(build_forestclaw)

set(_ld ${PROJECT_BINARY_DIR}/lib)

set(forestclaw_LIBRARY ${_ld}/${CMAKE_STATIC_LIBRARY_PREFIX}forestclaw${CMAKE_STATIC_LIBRARY_SUFFIX} CACHE FILEPATH "forestclaw library" FORCE)
set(p4est_LIBRARY ${_ld}/${CMAKE_STATIC_LIBRARY_PREFIX}p4est${CMAKE_STATIC_LIBRARY_SUFFIX} CACHE FILEPATH "p4est library" FORCE)
set(sc_LIBRARY ${_ld}/${CMAKE_STATIC_LIBRARY_PREFIX}sc${CMAKE_STATIC_LIBRARY_SUFFIX} CACHE FILEPATH "sc library" FORCE)

set(forestclaw_flags --prefix=${PROJECT_BINARY_DIR})
set(forestclaw_mpi)
if(MPI_C_FOUND)
  set(forestclaw_mpi --enable-mpi)
endif()

ExternalProject_Add(forestclaw
GIT_REPOSITORY https://github.com/ForestClaw/forestclaw.git
GIT_TAG master
UPDATE_DISCONNECTED true  # need this to avoid constant rebuild
CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/forestclaw-prefix/src/forestclaw/configure ${forestclaw_flags} ${forestclaw_mpi}
BUILD_COMMAND make -j${Ncpu}
INSTALL_COMMAND make -j${Ncpu} install
TEST_COMMAND ""
BUILD_BYPRODUCTS ${forestclaw_LIBRARY} ${p4est_LIBRARY} ${sc_LIBRARY}
)

ExternalProject_Get_Property(forestclaw SOURCE_DIR)

ExternalProject_Add_Step(forestclaw
  bootstrap
  COMMAND ./bootstrap
  DEPENDEES download
  DEPENDERS configure
  WORKING_DIRECTORY ${SOURCE_DIR})

set(p4est_LIBRARIES ${p4est_LIBRARY} ${sc_LIBRARY} PARENT_SCOPE)
set(forestclaw_LIBRARIES ${forestclaw_LIBRARY} PARENT_SCOPE)

endfunction(build_forestclaw)

build_forestclaw()


# --- imported target

find_package(ZLIB REQUIRED)

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include)  # avoid race condition

add_library(p4est::p4est INTERFACE IMPORTED GLOBAL)
target_include_directories(p4est::p4est INTERFACE ${PROJECT_BINARY_DIR}/include)
target_link_libraries(p4est::p4est INTERFACE "${p4est_LIBRARIES}" ZLIB::ZLIB m)  # need the quotes to expand list
# set_target_properties didn't work, but target_link_libraries did work
if(MPI_C_FOUND)
  target_link_libraries(p4est::p4est INTERFACE MPI::MPI_C)
endif(MPI_C_FOUND)
add_dependencies(p4est::p4est forestclaw)

add_library(forestclaw::forestclaw INTERFACE IMPORTED GLOBAL)
target_include_directories(forestclaw::forestclaw INTERFACE ${PROJECT_BINARY_DIR}/include)
target_link_libraries(forestclaw::forestclaw INTERFACE "${forestclaw_LIBRARIES}" p4est::p4est)  # need the quotes to expand list
