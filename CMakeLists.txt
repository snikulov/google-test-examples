cmake_minimum_required(VERSION 2.6)

project(google-testing)

ADD_DEFINITIONS(-g -Wall -ansi -Wno-deprecated -pthread)

enable_testing()
find_package(GTest REQUIRED)

include_directories(${GTEST_INCLUDE_DIRS})

add_executable(gootest1 gtest-test1.cpp)
target_link_libraries(gootest1 ${GTEST_BOTH_LIBRARIES} pthread)

add_executable(gootest2 gtest-test2.cpp)
target_link_libraries(gootest2 ${GTEST_BOTH_LIBRARIES} pthread)


add_test(test1 gootest1)
add_test(test2 gootest2)
