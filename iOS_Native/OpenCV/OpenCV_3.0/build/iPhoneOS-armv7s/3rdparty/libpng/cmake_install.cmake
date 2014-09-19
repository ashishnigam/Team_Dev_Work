# Install script for directory: /Users/ashish.nigam/Downloads/opencv/3rdparty/libpng

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/ashish.nigam/Downloads/ios/build/iPhoneOS-armv7s/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "dev")
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib" TYPE STATIC_LIBRARY FILES "/Users/ashish.nigam/Downloads/ios/build/iPhoneOS-armv7s/3rdparty/lib/Debug/liblibpng.a")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a")
      execute_process(COMMAND ":" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a")
    endif()
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib" TYPE STATIC_LIBRARY FILES "/Users/ashish.nigam/Downloads/ios/build/iPhoneOS-armv7s/3rdparty/lib/Release/liblibpng.a")
    if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a")
      execute_process(COMMAND ":" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/3rdparty/lib/liblibpng.a")
    endif()
  endif()
endif()

