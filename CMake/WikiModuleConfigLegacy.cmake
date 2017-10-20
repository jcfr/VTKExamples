
#
# This CMake module implements the legacy logic that is used
# to find and load the VTK dependencies needed by this project.
#
# Following the improvement of VTK build system following
# commit kitware/VTK@061eff0 from October 18th 2017 this approach
# stopped working.
#

if(${VTK_VERSION} VERSION_GREATER "8.1" OR ${VTK_VERSION} VERSION_EQUAL "8.1")
  return()
endif()

get_filename_component(WikiExample_MODULE_CONFIG ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
message(STATUS "VTKWikiExamples:")
message(STATUS "VTKWikiExamples: Including VTK using: ${WikiExample_MODULE_CONFIG}")
message(STATUS "VTKWikiExamples:")

if(Module_WikiExamples)
  #
  # This is a VTK remote module build
  #
  vtk_module_impl()
  if(NOT EXISTS "${VTK_BINARY_DIR}/VTKConfig.cmake")
    return()
  endif()
  find_package(VTK PATHS ${VTK_BINARY_DIR})
  include(${VTK_USE_FILE})
else()
  #
  # This is a stand-alone build
  #

  # See if VTK is using OpenGL or OpenGL2
  find_package(VTK CONFIG)
  if (NOT VTK_RENDERING_BACKEND)
    set(VTK_RENDERING_BACKEND OpenGL)
  endif()
  find_package(VTK REQUIRED)
  include(${VTK_USE_FILE})
endif()
