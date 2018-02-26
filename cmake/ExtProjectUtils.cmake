include(ExternalProject)
include(CMakeParseArguments)

#
# Function to inject dependency (download from git repo)
#
# Use as ExternalProjectGit( "<url to git repository>" "<tag>" "<destination>" )
#     where
#     - url to repository for ex. https://github.com/log4cplus/log4cplus.git
#       project name will be regexed from url as latest part in our case log4cplus.git
#     - tag - tag you want to use
#     - destination - where to install your binaries, for example ${CMAKE_BINARY_DIR}/3rdparty
#

function(ExtProjectGit repourl tag destination)

    message(STATUS "Get external project from: ${repourl} : ${tag}")

    string(REGEX MATCH "([^\\/]+)[.]git$" _name ${repourl})
    message(STATUS "_name = ${_name}")

    set(options)
    set(oneValueArgs)
    set(multiValueArgs CMAKE_ARGS)
    cmake_parse_arguments(ExtProjectGit "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(cmake_cli_args -DCMAKE_INSTALL_PREFIX=${destination}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
    if(CMAKE_TOOLCHAIN_FILE)
        get_filename_component(_ft_path ${CMAKE_TOOLCHAIN_FILE} ABSOLUTE)
        get_filename_component(_cm_rt_opath ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ABSOLUTE)
        set(cmake_cli_args ${cmake_cli_args}
          -DCMAKE_TOOLCHAIN_FILE=${_ft_path}
          -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${_cm_rt_opath})
    endif()

    foreach(cmake_key ${ExtProjectGit_CMAKE_ARGS})
        set(cmake_cli_args ${cmake_key} ${cmake_cli_args})
    endforeach()

    message(STATUS "ARGS for ExternalProject_Add(${name}): ${cmake_cli_args}")
    message(STATUS "CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")

    ExternalProject_Add(${_name}
        GIT_REPOSITORY ${repourl}
        GIT_TAG ${tag}
        CMAKE_ARGS -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${cmake_cli_args} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
        PREFIX "${destination}"
        INSTALL_DIR "${destination}")
endfunction()
