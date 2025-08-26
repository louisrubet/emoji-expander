cmake_minimum_required(VERSION 3.5)
include(GNUInstallDirs)

project(remo)
add_executable(remo main.cpp)
install(TARGETS remo DESTINATION ${CMAKE_INSTALL_BINDIR})
