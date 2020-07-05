cmake_minimum_required(VERSION 2.8.12)

project(main)

set(PROJECT_LIBS "")
set(CMAKE_CXX_STANDARD 14)

include_directories("-I/usr/include/eigen3")
find_package(BLAS)
include_directories(${BLAS_INCLUDE_DIRS})
set(PROJECT_LIBS ${BLAS_LIBRARIES})
add_definitions(-DEIGEN_USE_MKL_ALL)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} ${PROJECT_LIBS})