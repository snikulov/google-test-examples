# Short sample how-to use Google C++ Test Framework in cmakeable projects

1. Google test will be downloaded from GitHub and built with your project

## How to use:

1. git clone https://github.com/snikulov/google-test-examples.git
2. cd google-test-examples
3. mkdir build
4. cd build
5. cmake ..
6. cmake --build .
7. ctest -VV

## CI status:

[![Build Status](https://travis-ci.org/snikulov/google-test-examples.svg?branch=master)](https://travis-ci.org/snikulov/google-test-examples) | [![Build status](https://ci.appveyor.com/api/projects/status/t30uakdk0awxy88p/branch/master?svg=true)](https://ci.appveyor.com/project/snikulov/google-test-examples/branch/master)

## Known issues:

- TBD
---

# How to use (alternativ with docker containers)

## Get repo
```bash
$ git clone https://github.com/snikulov/google-test-examples.git
$ cd google-test-examples
```

## CMake
We can use CMake to configure/build/running tests:

### Host side
```bash
$ cmake -P build.cmake
```

### Docker Containers side
```bash
cmake -P build_with_docker.cmake
```

## Makefile

### Targets
```bash
$ make [tab]
make all
all                        build/Makefile             configure                  google-test-examples_test
build                      clean                      DOCKER_COMMAND             run
build_directory            clean_docker_image         docker_image
build_docker_image         CMAKE_COMMAND              DOCKER_IMAGE
```

### Configure/Build/Running tests (with docker containers)
```bash
$ make all
docker build -t atty/google-test-examples:latest --file docker/Dockerfile .
Sending build context to Docker daemon  221.2kB
Step 1/1 : FROM rikorose/gcc-cmake:latest
...
1/1 Test #1: test1 ............................   Passed    0.00 sec
100% tests passed, 0 tests failed out of 1

Total Test time (real) =   0.00 sec
```

## Screencast recording
[![asciicast](https://asciinema.org/a/a03v5lmsoph7l0lhish1jkwqo.png)](https://asciinema.org/a/a03v5lmsoph7l0lhish1jkwqo)
