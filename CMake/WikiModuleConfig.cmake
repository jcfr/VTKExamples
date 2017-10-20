
#
# This CMake module implements the logic required to build this project
# following commit kitware/VTK@061eff0 from October 18th 2017.
#
# The VTK build system was one of the first modular one to be setup and
# didn't allow to build VTK module as standalone project so that
# they could be packaged independently and also depended one for buidling
# other module.
#

if(${VTK_VERSION} VERSION_LESS "8.1")
  return()
endif()

get_filename_component(WikiExample_MODULE_CONFIG ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
message(STATUS "VTKWikiExamples:")
message(STATUS "VTKWikiExamples: Including VTK using: ${WikiExample_MODULE_CONFIG}")
message(STATUS "VTKWikiExamples:")

if(NOT VTK_BINARY_DIR)
  include(vtkExternalModuleMacros)
endif()

# Load up the CMake variables we need.
vtk_module_export_info()

# List of optional VTK dependencies.
set(WikiExamples_OPTIONAL_DEPENDS
  vtkFiltersParallelStatistics
  vtkInfovisBoostGraphAlgorithms
  vtkInfovisViews
  vtkIOFFMPEG
  vtkIOMySQL
  vtkGUISupportQtOpenGL
  vtkRenderingQt
  vtkViewsQt
  )

# Optional dependency are loaded only if enabled.
foreach(optional-depends IN LISTS WikiExamples_OPTIONAL_DEPENDS)
  # XXX See below "Limitations on handling optional dependencies"
  if(TARGET ${optional-depends} OR Module_${optional-depends})
    list(APPEND ${vtk-module}_DEPENDS ${optional-depends})
  endif()
endforeach()

# Load requested modules and their dependencies into variables:
#  VTK_DEFINITIONS     = Preprocessor definitions
#  VTK_LIBRARIES       = Libraries to link
#  VTK_INCLUDE_DIRS    = Header file search path
#  VTK_LIBRARY_DIRS    = Library search path (for outside dependencies)
vtk_module_config(VTK ${${vtk-module}_DEPENDS})


#
#
# Limitations on handling optional dependencies
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# When this module is built as a remote module within VTK, it
# is not possible to dynamically update the DAG based on
# availability of the optional VTK modules it should depend on.
#
# To workaround this limitation, we perform the following tests:
#
# (1) testing for the availability of the target:
#
#      - This always works for a stand-alone build because the targets
#         were imported in VTKConfig.
#
#      - but for a remote build where VTKConfig is only generated at
#        the end of the configuration, it will work only for the
#        optional dependencies that **happen to be enabled** before
#        this module.
#
# (2) testing for Module_${optional-depends}: This is useful only
#     for the remote build and allow to detect the case where the user
#     explicitly enable a module.
#
# Ideally, the module API should be extended to support an
# OPTIONAL_DEPENDS property.
#
