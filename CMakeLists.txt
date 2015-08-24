# This a sample CMakeLists.txt for compiling plug for Switchboard
# http://elementaryos.org/docs/developer-guide/cmake 

cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

set (PLUGNAME "pantheon-mouse-touchpad")
# Set the Category of the Plug, one of:
# personal, hardware, network, system
set (PLUGCATEGORY "hardware")
# Set the Title to use for the Plug in the Overview and in the Titlebar
set (PLUGTITLE "Mouse - Touchpad")
set (PLUGDESCRIPTION "Mouse and touchpad settings")

set (PLUGICON "preferences-desktop-peripherals")
# Set the version for the plug
set (VERSION "0.1")

# Set the Name of the plug, should be an executable command, lowercase, no spaces 
project (${PLUGNAME})

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

include (GNUInstallDirs)
set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
set (PKGDATADIR "${DATADIR}/${PLUGCATEGORY}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${PLUGNAME}")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (plug.plugin ${CMAKE_BINARY_DIR}/${PLUGNAME}.plugin)
install (FILES ${CMAKE_BINARY_DIR}/${PLUGNAME}.plugin DESTINATION ${PKGDATADIR})
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Traslation stuff
add_subdirectory (po)

add_subdirectory(src)
