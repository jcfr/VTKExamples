cmake_minimum_required(VERSION 3.3 FATAL_ERROR)

project(WikiExamples)

# Display type of build
set(_msg "VTKWikiExamples: Building VTKWikiExamples stand-alone")
message(STATUS "${_msg}")
if(VTK_BINARY_DIR)
  message(STATUS "${_msg} - no")
else()
  message(STATUS "${_msg} - yes")
endif()

# Setup dependencies
if(NOT VTK_BINARY_DIR)
  find_package(VTK REQUIRED)
endif()
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${VTK_CMAKE_DIR}")
if(NOT VTK_BINARY_DIR)
  include(vtkExternalModuleMacros)
endif()
message(STATUS "VTKWikiExamples: Found VTK VERSION: ${VTK_VERSION}(${VTK_RENDERING_BACKEND})")

# Display build properties
set(_msg "VTKWikiExamples: Setting executables prefix")
message(STATUS "${_msg}")
if(VTK_BINARY_DIR)
  set(WIKI "wiki")
  message(STATUS "${_msg} - yes [prefix: ${WIKI}]")
else()
  set(WIKI "")
  message(STATUS "${_msg} - no")
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
  #
  # XXX When this module is built as a remote module within VTK, it
  #     is not possible to dynamically update the DAG based on
  #     availability of the optional VTK modules it should depend on.
  #
  #     To workaround this limitation, we perform the following tests:
  #
  #     (1) testing for the availability of the target:
  #
  #          - This always works for a stand-alone build because the targets
  #             were imported in VTKConfig.
  #
  #          - but for a remote build where VTKConfig is only generated at
  #            the end of the configuration, it will work only for the
  #            optional dependencies that **happen to be enabled** before
  #            this module.
  #
  #     (2) testing for Module_${optional-depends}: This is useful only
  #         for the remote build and allow to detect the case where the user
  #         explicitly enable a module.
  #
  #     Ideally, the module API should be extended to support an
  #     OPTIONAL_DEPENDS property.
  #
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

#-----------------------------------------------------------------------------
# Set project options
set(CMAKE_MODULE_PATH
  ${WikiExamples_SOURCE_DIR}/CMake
  ${CMAKE_MODULE_PATH}
  )
include(WikiOutputDirectories)
include(WikiPlatformSpecificChecks)
include(WikiPolicies)
include(WikiTesting)

#-----------------------------------------------------------------------------
# Mac specific
IF(APPLE)
  SET(EXECUTABLE_FLAG MACOSX_BUNDLE)
ENDIF(APPLE)

#-----------------------------------------------------------------------------
ADD_SUBDIRECTORY(src/Cxx/Animation)
ADD_SUBDIRECTORY(src/Cxx/CompositeData)
IF(VTK_USE_MYSQL)
  ADD_SUBDIRECTORY(src/Cxx/Databases)
ENDIF(VTK_USE_MYSQL)
ADD_SUBDIRECTORY(src/Cxx/DataStructures)
if(${VTK_VERSION} VERSION_GREATER "6.10")
  ADD_SUBDIRECTORY(src/Cxx/Developers)
endif()
ADD_SUBDIRECTORY(src/Cxx/Filtering)
ADD_SUBDIRECTORY(src/Cxx/GeometricObjects)
IF(VTK_USE_INFOVIS)
  IF(VTK_USE_BOOST)
    ADD_SUBDIRECTORY(src/Cxx/Graphs)
  ENDIF(VTK_USE_BOOST)
ENDIF(VTK_USE_INFOVIS)
ADD_SUBDIRECTORY(src/Cxx/ImageData)
ADD_SUBDIRECTORY(src/Cxx/Geovis)
ADD_SUBDIRECTORY(src/Cxx/HyperTreeGrid)
ADD_SUBDIRECTORY(src/Cxx/Images)
ADD_SUBDIRECTORY(src/Cxx/ImplicitFunctions)
ADD_SUBDIRECTORY(src/Cxx/InfoVis)
ADD_SUBDIRECTORY(src/Cxx/Interaction)
ADD_SUBDIRECTORY(src/Cxx/IO)
ADD_SUBDIRECTORY(src/Cxx/Lighting)
ADD_SUBDIRECTORY(src/Cxx/Math)
ADD_SUBDIRECTORY(src/Cxx/Medical)
ADD_SUBDIRECTORY(src/Cxx/Meshes)
ADD_SUBDIRECTORY(src/Cxx/Modelling)
IF(VTK_USE_PARALLEL)
  ADD_SUBDIRECTORY(src/Cxx/Parallel)
ENDIF(VTK_USE_PARALLEL)
ADD_SUBDIRECTORY(src/Cxx/Picking)
ADD_SUBDIRECTORY(src/Cxx/Plotting)
ADD_SUBDIRECTORY(src/Cxx/PolyData)
ADD_SUBDIRECTORY(src/Cxx/Points)
ADD_SUBDIRECTORY(src/Cxx/RectilinearGrid)
ADD_SUBDIRECTORY(src/Cxx/Remote)
ADD_SUBDIRECTORY(src/Cxx/Rendering)
ADD_SUBDIRECTORY(src/Cxx/RenderMan)
ADD_SUBDIRECTORY(src/Cxx/SimpleOperations)
ADD_SUBDIRECTORY(src/Cxx/StructuredGrid)
ADD_SUBDIRECTORY(src/Cxx/StructuredPoints)
ADD_SUBDIRECTORY(src/Cxx/Texture)
ADD_SUBDIRECTORY(src/Cxx/UnstructuredGrid)
ADD_SUBDIRECTORY(src/Cxx/Utilities)
ADD_SUBDIRECTORY(src/Cxx/Video)
IF(VTK_USE_VIEWS)
  ADD_SUBDIRECTORY(src/Cxx/Views)
ENDIF(VTK_USE_VIEWS)
ADD_SUBDIRECTORY(src/Cxx/Visualization)
ADD_SUBDIRECTORY(src/Cxx/VisualizationAlgorithms)
ADD_SUBDIRECTORY(src/Cxx/VolumeRendering)
ADD_SUBDIRECTORY(src/Cxx/Widgets)

# ADD_SUBDIRECTORY(Python/GeometricObjects)

if(vtkGUISupportQt_LOADED)
  message(STATUS "VTKWikiExamples: Building Qt examples")
  if(${VTK_VERSION} VERSION_GREATER "6" AND VTK_QT_VERSION VERSION_GREATER "4")
    # Instruct CMake to run moc automatically when needed.
    set(CMAKE_AUTOMOC ON)
    # We have ui files, this will bring in the macro: qt5_wrap_ui
    find_package(Qt5Widgets REQUIRED QUIET)
  else()
    FIND_PACKAGE(Qt4 REQUIRED)
    INCLUDE(${QT_USE_FILE})
  endif()
  ADD_SUBDIRECTORY(src/Cxx/Qt)
else()
  message(STATUS "VTKWikiExamples: Not building Qt examples")
endif()
