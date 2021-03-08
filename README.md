Archived because forestclaw now has CMake

---

# forestclaw-cmake

![ci](https://github.com/scivision/p4est-cmake/workflows/ci/badge.svg)

Building [forestclaw](https://github.com/ForestClaw/forestclaw) as a CMake ExternalProject for easier use in CMake projects on Linux and MacOS.
Windows has platform-specific issues, so it is probably easier to use Windows Subsystem for Linux.

The CMake script runs `bootstrap`, `configure`, `make`, `make install`.
On a good desktop PC it takes about 3 minutes to build.

## Usage

As with most CMake projects:

```sh
cmake -B build
cmake --build build
```

Since this project consumes forestclaw as an [ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html), forestclaw is downloaded, built, and tested upon the "cmake --build" command.

### Artifacts

Binary artifacts (test exectuables) are created under "build/".

* bin: test exectuables
* include: *.h headers
* lib: forestclaw, p4est, sc

### Prereqs

MacOS: assuming Homebrew is used:

```sh
brew install gcc cmake make openmpi autoconf automake libtool
```
